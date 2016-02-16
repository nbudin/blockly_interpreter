class BlocklyInterpreter::CoreBlocks::LogicalOperatorBlock < BlocklyInterpreter::Block
  self.block_type = :logic_operation

  def value(execution_context)
    case fields['OP']
    when 'AND' then values['A'].value(execution_context) && values['B'].value(execution_context)
    when 'OR' then values['A'].value(execution_context) || values['B'].value(execution_context)
    end
  end

  def to_dsl
    BlocklyInterpreter::DSL::BinaryOperationDSLGenerator.new(self, "logic_operation").dsl
  end

  module DSLMethods
    def logic_operation(op, a = nil, b = nil, &proc)
      @blocks << BlocklyInterpreter::DSL::BinaryOperationBlockBuilder.new("logic_operation", op, a, b).tap do |builder|
        builder.instance_exec(&proc) if block_given?
      end
    end
  end
end