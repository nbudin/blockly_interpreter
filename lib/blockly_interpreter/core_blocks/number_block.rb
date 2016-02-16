class BlocklyInterpreter::CoreBlocks::NumberBlock < BlocklyInterpreter::Block
  self.block_type = :math_number

  def num
    fields['NUM'].to_i
  end

  def value(execution_context)
    num
  end

  def to_dsl
    "math_number #{num.inspect}"
  end

  module DSLMethods
    def math_number(n)
      block :math_number do
        field :NUM, n.to_s
      end
    end
  end
end