class BlocklyInterpreter::CoreBlocks::ListsCreateEmptyBlock < BlocklyInterpreter::Block
  self.block_type = :lists_create_empty

  def value(execution_context)
    []
  end

  def to_dsl
    "lists_create_empty"
  end

  module DSLMethods
    def lists_create_empty
      block :lists_create_empty
    end
  end
end