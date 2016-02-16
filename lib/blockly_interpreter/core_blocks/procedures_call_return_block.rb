class BlocklyInterpreter::CoreBlocks::ProceduresCallReturnBlock < BlocklyInterpreter::CoreBlocks::ProcedureBlock
  self.block_type = :procedures_callreturn

  def procedure_name
    @procedure_name ||= mutation.try!(:[], 'name')
  end

  def value(execution_context)
    execution_context.value_for_procedure(procedure_name, arg_values(execution_context))
  end

  module DSLMethods
    def procedures_callreturn(name, &proc)
      builder = BlocklyInterpreter::CoreBlocks::ProcedureBlock::DSLMethods::ProcedureCallBlockBuilder.new("procedures_callreturn", name)

      @blocks << builder.tap do |builder|
        builder.instance_exec(&proc) if proc
      end
    end
  end
end