class BlocklyInterpreter::CoreBlocks::ProceduresDefNoReturnBlock < BlocklyInterpreter::CoreBlocks::ProcedureBlock
  self.block_type = :procedures_defnoreturn

  def procedure_name
    fields['NAME']
  end

  def execute_statement(execution_context)
    execution_context.execute(statements['STACK'])
  end

  def to_dsl
    method_call_with_possible_block("procedures_defnoreturn", ([procedure_name] + arg_names).map(&:inspect).join(", "), statements['STACK'])
  end

  module DSLMethods
    def procedures_defnoreturn(name, *arg_names, &proc)
      block :procedures_defnoreturn do
        field :NAME, name

        arg_names.each do |arg_name|
          mutation_child :arg do |child|
            child['name'] = arg_name
          end
        end

        statement :STACK, &proc
      end
    end
  end
end