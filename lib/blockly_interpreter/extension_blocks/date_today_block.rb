class BlocklyInterpreter::ExtensionBlocks::DateTodayBlock < BlocklyInterpreter::Block
  self.block_type = :date_today

  def value(execution_context)
    Date.today
  end

  def to_dsl
    "date_today"
  end

  module DSLMethods
    def date_today
      block :date_today
    end
  end
end