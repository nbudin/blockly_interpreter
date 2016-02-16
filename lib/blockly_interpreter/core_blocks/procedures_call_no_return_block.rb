class BlocklyInterpreter::CoreBlocks::ProceduresCallNoReturnBlock < BlocklyInterpreter::CoreBlocks::ProcedureBlock
  self.block_type = :procedures_callnoreturn

  def procedure_name
    @procedure_name ||= mutation.try!(:[], 'name')
  end

  def execute_statement(execution_context)
    execution_context.execute_procedure(procedure_name, arg_values(execution_context))
  end

  module DSLMethods
    def procedures_callnoreturn(name, &proc)
      builder = BlocklyInterpreter::CoreBlocks::ProcedureBlock::DSLMethods::ProcedureCallBlockBuilder.new("procedures_callnoreturn", name)

      @blocks << builder.tap do |builder|
        builder.instance_exec(&proc) if proc
      end
    end
  end
end