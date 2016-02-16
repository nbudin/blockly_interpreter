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
end