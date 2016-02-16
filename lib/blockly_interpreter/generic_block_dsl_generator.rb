class BlocklyInterpreter::GenericBlockDSLGenerator
  include BlocklyInterpreter::DSLGenerator

  attr_reader :block

  def initialize(block)
    @block = block
  end

  def dsl
    method_call_with_possible_block("block", block.class.block_type.to_sym.inspect, block_contents)
  end

  private
  def mutation_attributes_dsl(mutation)
    mutation.attributes.keys.map do |attribute|
      "mutation_attr #{attribute.inspect}, #{mutation[attribute].inspect}"
    end
  end

  def mutation_child_dsl(child)
    attributes_dsl = child.attributes.keys.map do |child_attribute|
      "child[#{child_attribute.inspect}] = #{child[child_attribute].inspect}"
    end

    if child.inner_html.present?
      attributes_dsl << "child.inner_html = #{child.inner_html.inspect}"
    end

    method_call_with_possible_block("mutation_child", child.name.inspect, attributes_dsl, "child")
  end

  def mutation_dsl
    if block.mutation
      mutation_attributes_dsl(block.mutation) + block.mutation.children.map do |child|
        mutation_child_dsl(child)
      end
    else
      []
    end
  end

  def fields_dsl
    block.fields.map do |key, value|
      "field #{key.inspect}, #{value.inspect}"
    end
  end

  def values_dsl
    block.values.map do |key, value_block|
      method_call_with_possible_block("value", key.inspect, value_block) + "\n"
    end
  end

  def statements_dsl
    block.statements.map do |key, statement_block|
      method_call_with_possible_block("statement", key.inspect, statement_block) + "\n"
    end
  end

  def block_contents
    @block_contents ||= (mutation_dsl + fields_dsl + values_dsl + statements_dsl)
  end
end