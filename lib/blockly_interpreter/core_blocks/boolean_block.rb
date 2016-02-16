class BlocklyInterpreter::CoreBlocks::BooleanBlock < BlocklyInterpreter::Block
  self.block_type = :logic_boolean

  def to_bool
    fields['BOOL'] == 'TRUE'
  end

  def value(execution_context)
    to_bool
  end

  def to_dsl
    "logic_boolean #{to_bool.inspect}"
  end

  module DSLMethods
    def logic_boolean(value)
      block :logic_boolean do
        field :BOOL, value ? "TRUE" : "FALSE"
      end
    end
  end
end