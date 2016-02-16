class BlocklyInterpreter::CoreBlocks::SetVariableBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator

  self.block_type = :variables_set

  def execute_statement(execution_context)
    execution_context.set_variable(fields['VAR'], values['VALUE'].value(execution_context))
  end

  def to_dsl
    method_call_with_possible_block("variables_set", fields['VAR'].inspect, values['VALUE'])
  end

  module DSLMethods
    def variables_set(name, &proc)
      block :variables_set do
        field :VAR, name
        value :VALUE do
          instance_exec &proc
        end
      end
    end
  end
end