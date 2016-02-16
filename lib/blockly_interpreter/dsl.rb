require 'nokogiri'

module BlocklyInterpreter::DSL
  class BlockContext
    attr_reader :blocks, :procedure_blocks

    def self.register_block_class(block_class)
      if block_class.const_defined?(:DSLMethods)
        self.include block_class.const_get(:DSLMethods)
      end
    end

    def initialize
      @blocks = []
      @procedure_blocks = []
    end

    def block(block_type, &proc)
      @blocks << BlockBuilder.new(block_type).tap do |builder|
        builder.instance_exec(&proc) if proc
      end
    end

    def with_comment(comment, pinned = false, &proc)
      instance_exec(&proc)
      @blocks.last.tap { |block| block.set_comment(comment, pinned) }
    end

    def shadow(&proc)
      instance_exec(&proc)
      @blocks.last.tap { |block| block.shadow! }
    end

    def with_position(x, y, &proc)
      instance_exec(&proc)
      @blocks.last.tap { |block| block.set_position!(x, y) }
    end

    def procedures(&proc)
      procedures_context = BlockContext.new.tap do |builder|
        builder.instance_exec(&proc) if proc
      end

      @procedure_blocks.push(*procedures_context.blocks)
    end

    def to_xml(doc, block_index = 0)
      return unless blocks.any?

      block = blocks[block_index]
      Nokogiri::XML::Node.new(block.tag_name, doc).tap do |node|
        blocks[block_index].to_xml(node)

        if blocks.size > block_index + 1
          next_node = Nokogiri::XML::Node.new('next', doc)
          next_node.add_child to_xml(doc, block_index + 1)
          node.add_child(next_node)
        end
      end
    end
  end

  class BlockBuilder
    attr_reader :block_type, :values, :statements, :fields, :mutation_attrs, :mutation_child_procs, :comment, :comment_pinned, :is_shadow, :x, :y

    def initialize(block_type)
      @block_type = block_type
      @values = {}
      @statements = {}
      @fields = {}
      @mutation_attrs = {}
      @mutation_child_procs = []
      @comment = nil
      @comment_pinned = nil
      @is_shadow = false
      @x = nil
      @y = nil
    end

    def to_xml(node)
      node['type'] = block_type
      document = node.document

      node['x'] = x if x
      node['y'] = y if y

      node.add_child(mutations_to_xml(document)) if mutation_attrs.any? || mutation_child_procs.any?
      node.add_child(comment_to_xml(document)) if comment.present?

      values.each do |name, context|
        node.add_child subblock_to_xml('value', name, context, document)
      end

      statements.each do |name, context|
        node.add_child subblock_to_xml('statement', name, context, document)
      end

      fields.each do |name, value|
        node.add_child field_to_xml(name, value, document)
      end
    end

    def subblock_to_xml(tag_name, subblock_name, context, doc)
      Nokogiri::XML::Node.new(tag_name, doc).tap do |node|
        node['name'] = subblock_name
        node.add_child context.to_xml(doc)
      end
    end

    def mutations_to_xml(document)
      Nokogiri::XML::Node.new('mutation', document).tap do |mutation_node|
        mutation_attrs.each do |name, value|
          mutation_node[name] = value.to_s
        end

        mutation_child_procs.each do |(tag_name, proc)|
          child = Nokogiri::XML::Node.new(tag_name.to_s, document)
          proc.call(child)
          mutation_node.add_child child
        end
      end
    end

    def field_to_xml(name, value, document)
      Nokogiri::XML::Node.new('field', document).tap do |field_node|
        field_node['name'] = name
        field_node.add_child Nokogiri::XML::Text.new(value.to_s, document)
      end
    end

    def comment_to_xml(document)
      Nokogiri::XML::Node.new('comment', document).tap do |comment_node|
        comment_node.content = comment
        comment_node['pinned'] = comment_pinned.inspect unless comment_pinned.nil?
      end
    end

    def build_subblock(&proc)
      BlockContext.new.tap do |builder|
        builder.instance_exec(&proc)
      end
    end

    def value(name, &proc)
      @values[name.to_s] = build_subblock(&proc)
    end

    def statement(name, &proc)
      @statements[name.to_s] = build_subblock(&proc)
    end

    def field(name, value)
      @fields[name.to_s] = value
    end

    def mutation_attr(name, value)
      @mutation_attrs[name.to_s] = value
    end

    def mutation_child(tag_name, &proc)
      @mutation_child_procs << [tag_name, proc]
    end

    def set_comment(comment, pinned = false)
      @comment = comment
      @comment_pinned = pinned
    end

    def set_position!(x, y)
      @x = x
      @y = y
    end

    def tag_name
      if is_shadow
        'shadow'
      else
        'block'
      end
    end

    def shadow!
      @is_shadow = true
    end
  end

  class BinaryOperationBlockBuilder < BlockBuilder
    def initialize(block_type, op, a = nil, b = nil)
      super block_type
      field :OP, op

      a(a) unless a.nil?
      b(b) unless b.nil?
    end

    def cast_static_value_proc(static_value)
      case static_value
      when Numeric then -> { math_number(static_value) }
      when String then -> { text(static_value) }
      when true, false then -> { logic_boolean(static_value) }
      end
    end

    def value_with_static_option(name, static_value = nil, &proc)
      proc ||= cast_static_value_proc(static_value)
      value name, &proc
    end

    def a(static_value = nil, &proc)
      value_with_static_option :A, static_value, &proc
    end

    def b(static_value = nil, &proc)
      value_with_static_option :B, static_value, &proc
    end
  end

  class BinaryOperationDSLGenerator
    include BlocklyInterpreter::DSLGenerator

    attr_reader :block, :dsl_method_name

    def initialize(block, dsl_method_name)
      @block = block
      @dsl_method_name = dsl_method_name
    end

    def castable_static_value(value)
      case value
      when BlocklyInterpreter::CoreBlocks::NumberBlock then value.fields['NUM'].to_i
      when BlocklyInterpreter::CoreBlocks::BooleanBlock then value.to_bool
      when BlocklyInterpreter::CoreBlocks::TextBlock then value.fields['TEXT']
      end
    end

    def cast_operands
      @cast_operands ||= begin
        a, b = ['A', 'B'].map { |value_name| block.values[value_name] }
        [a, b].map { |value| castable_static_value value }
      end
    end

    def value_block(value_name, cast_operand)
      return if cast_operand
      method_call_with_block_or_nothing(value_name.downcase, '', block.values[value_name])
    end

    def block_contents
      cast_a, cast_b = cast_operands
      [
        value_block('A', cast_a),
        value_block('B', cast_b)
      ].compact
    end

    def method_args
      args = [block.fields['OP'].to_sym.inspect]
      cast_a, cast_b = cast_operands

      args << cast_a.inspect if cast_a || cast_b
      args << cast_b.inspect if cast_b

      args
    end

    def dsl
      method_call_with_possible_block(dsl_method_name, method_args.join(', '), block_contents)
    end
  end

  def self.build_xml(&block)
    doc = Nokogiri::XML::Document.new
    root = Nokogiri::XML::Node.new('xml', doc)
    root['xmlns'] = 'http://www.w3.org/1999/xhtml'
    doc.add_child root

    context = BlockContext.new
    context.instance_exec(&block)
    first_block = context.to_xml(doc)
    root.add_child(first_block) if first_block

    context.procedure_blocks.each do |proc|
      Nokogiri::XML::Node.new(proc.tag_name, doc).tap do |node|
        proc.to_xml(node)
        root.add_child(node)
      end
    end

    doc.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::NO_DECLARATION | Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS)
  end
end