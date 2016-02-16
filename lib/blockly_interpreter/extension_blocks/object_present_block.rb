class BlocklyInterpreter::ExtensionBlocks::ObjectPresentBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator

  self.block_type = :object_present

  def value(execution_context)
    values['VALUE'].try!(:value, execution_context).present?
  end

  def to_dsl
    method_call_with_possible_block("object_present", "", values['VALUE'])
  end

  module DSLMethods
    def object_present(&proc)
      block :object_present do
        value :VALUE, &proc
      end
    end
  end
end