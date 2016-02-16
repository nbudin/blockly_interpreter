class BlocklyInterpreter::CoreBlocks::TextChangeCaseBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = :text_changeCase

  def destination_case
    fields['CASE']
  end

  def value(execution_context)
    text = values['TEXT'].value(execution_context).to_s

    case destination_case
    when 'UPPERCASE' then text.upcase
    when 'LOWERCASE' then text.downcase
    when 'TITLECASE' then text.titleize
    else raise "Unknown case: #{destination_case.inspect}"
    end
  end

  def to_dsl
    method_call_with_possible_block "text_change_case", destination_case.inspect, values['TEXT']
  end

  module DSLMethods
    def text_change_case(destination_case, &proc)
      block :text_changeCase do
        field :CASE, destination_case
        value :TEXT, &proc
      end
    end
  end
end