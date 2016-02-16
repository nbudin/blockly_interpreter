class BlocklyInterpreter::CoreBlocks::ArithmeticOperatorBlock < BlocklyInterpreter::Block
  self.block_type = :math_arithmetic

  def value(execution_context)
    a = values['A'].value(execution_context)
    b = values['B'].value(execution_context)

    case fields['OP'].to_s.upcase
    when 'ADD' then a + b
    when 'MINUS' then a - b
    when 'MULTIPLY' then a * b
    when 'DIVIDE' then a / b
    when 'POWER' then a ** b
    end
  end

  module DSLMethods
    def math_arithmetic(op, a = nil, b = nil, &proc)
      @blocks << BlocklyInterpreter::DSL::BinaryOperationBlockBuilder.new("math_arithmetic", op, a, b).tap do |builder|
        builder.instance_exec(&proc) if block_given?
      end
    end
  end
end