require 'nokogiri'

class BlocklyInterpreter::Block
  class << self
    attr_accessor :block_type
  end

  attr_reader :block_type, :values, :statements, :fields, :next_block, :mutation, :comment, :comment_pinned, :is_shadow, :x, :y
  alias_method :is_shadow?, :is_shadow

  def initialize(block_type, fields, values, statements, next_block, mutation, comment, comment_pinned, is_shadow, x, y)
    @block_type = block_type
    @fields = fields
    @values = values
    @statements = statements
    @next_block = next_block
    @mutation = mutation
    @comment = comment
    @comment_pinned = comment_pinned
    @is_shadow = is_shadow
    @x = x
    @y = y
  end

  def execute_statement(execution_context)
  end

  def value(execution_context)
    nil
  end

  def each_block(iterate_subblocks = true)
    return to_enum(:each_block, iterate_subblocks) unless block_given?

    yield self

    if iterate_subblocks
      statements.each do |key, statement|
        statement.each_block(iterate_subblocks) do |block|
          yield block
        end
      end
    end

    if next_block
      next_block.each_block(iterate_subblocks) do |block|
        yield block
      end
    end
  end

  def to_dsl
    BlocklyInterpreter::GenericBlockDSLGenerator.new(self).dsl
  end

  def has_comment?
    comment.present?
  end

  def has_position?
    x || y
  end

  def to_xml_element(document)
    tag_name = is_shadow ? 'shadow' : 'block'

    Nokogiri::XML::Element.new(tag_name, document).tap do |node|
      node['type'] = block_type
      node['x'] = x if x
      node['y'] = y if y
      node.add_child(mutation.dup) if mutation

      if comment
        comment_node = Nokogiri::XML::Element.new('comment', document)
        comment_node['pinned'] = 'true' if comment_pinned
        node.add_child comment_node
      end

      fields.each do |name, value|
        field_node = Nokogiri::XML::Element.new('field', document)
        field_node['name'] = name
        field_node.add_child Nokogiri::XML::Text.new(value, document)
        node.add_child field_node
      end

      values.each do |name, value|
        value_node = Nokogiri::XML::Element.new('value', document)
        value_node['name'] = name
        value_node.add_child value.to_xml_element(document)
        node.add_child value_node
      end

      statements.each do |name, value|
        statement_node = Nokogiri::XML::Element.new('statement', document)
        statement_node['name'] = name
        statement_node.add_child value.to_xml_element(document)
        node.add_child statement_node
      end

      if next_block
        next_block_node = Nokogiri::XML::Element.new('next_block', document)
        next_block_node.add_child next_block.to_xml_element(document)
        node.add_child next_block_node
      end
    end
  end

  def to_xml(options = {})
    doc = Nokogiri::XML::Document.new
    element = to_xml_element(doc)
    element.to_xml(options = {})
  end
end