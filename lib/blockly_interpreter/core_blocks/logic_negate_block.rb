class BlocklyInterpreter::CoreBlocks::LogicNegateBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = :logic_negate

  def value(execution_context)
    !values['BOOL'].value(execution_context)
  end

  def to_dsl
    method_call_with_possible_block("logic_negate", "", values['BOOL'])
  end

  module DSLMethods
    def logic_negate(&proc)
      block :logic_negate do
        value 'BOOL', &proc
      end
    end
  end
end