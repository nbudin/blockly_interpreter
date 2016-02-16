class BlocklyInterpreter::CoreBlocks::GetVariableBlock < BlocklyInterpreter::Block
  self.block_type = :variables_get

  def value(execution_context)
    execution_context.get_variable(fields['VAR'])
  end

  def to_dsl
    "variables_get #{fields['VAR'].inspect}"
  end

  module DSLMethods
    def variables_get(name)
      block :variables_get do
        field :VAR, name
      end
    end
  end
end