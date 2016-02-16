class BlocklyInterpreter::CoreBlocks::ComparisonOperatorBlock < BlocklyInterpreter::Block
  self.block_type = :logic_compare

  def value(execution_context)
    a = values['A'].value(execution_context)
    b = values['B'].value(execution_context)

    a, b = cast_values(a, b)

    begin
      case fields['OP']
      when 'EQ' then a == b
      when 'NEQ' then a != b
      when 'LT' then a < b
      when 'GT' then a > b
      when 'LTE' then a <= b
      when 'GTE' then a >= b
      end
    rescue
      false
    end
  end

  def to_dsl
    BlocklyInterpreter::DSL::BinaryOperationDSLGenerator.new(self, "logic_compare").dsl
  end

  module DSLMethods
    def logic_compare(op, a = nil, b = nil, &proc)
      @blocks << BlocklyInterpreter::DSL::BinaryOperationBlockBuilder.new("logic_compare", op, a, b).tap do |builder|
        builder.instance_exec(&proc) if block_given?
      end
    end
  end

  private

  def cast_values(a, b)
    return a, b if a.nil? && b.nil?
    return a, b if a.is_a?(b.class) || b.is_a?(a.class)

    if a.is_a?(Float) || b.is_a?(Float)
      [a.to_f, b.to_f]
    elsif a.is_a?(Integer) || b.is_a?(Integer)
      [a.to_i, b.to_i]
    else
      [a, b]
    end
  end
end