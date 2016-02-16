class BlocklyInterpreter::CoreBlocks::TextBlock < BlocklyInterpreter::Block
  self.block_type = :text

  def text
    fields['TEXT']
  end

  def value(execution_context)
    text
  end

  def to_dsl
    "text #{text.inspect}"
  end

  module DSLMethods
    def text(content)
      block :text do
        field :TEXT, content
      end
    end
  end
end