class BlocklyInterpreter::CoreBlocks::ProceduresIfReturnBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator

  self.block_type = :procedures_ifreturn

  def execute_statement(execution_context)
    if values['CONDITION'].value(execution_context).present?
      return_value = values['VALUE'].value(execution_context) if values['VALUE']
      execution_context.early_return!(return_value)
    end
  end

  def to_dsl
    block_contents = [method_call_with_possible_block("condition", "", values['CONDITION'])]
    block_contents << method_call_with_block_or_nothing("return_value", "", values['VALUE'])

    method_call_with_possible_block("procedures_ifreturn", "", block_contents.compact)
  end

  module DSLMethods
    class ProceduresIfReturnBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      def initialize(block_type)
        super
        mutation_attr :value, 0
      end

      def condition(&proc)
        value :CONDITION, &proc
      end

      def return_value(&proc)
        mutation_attr :value, 1
        value :VALUE, &proc
      end
    end

    def procedures_ifreturn(&proc)
      builder = BlocklyInterpreter::CoreBlocks::ProceduresIfReturnBlock::DSLMethods::ProceduresIfReturnBlockBuilder.new("procedures_ifreturn")

      @blocks << builder.tap do |builder|
        builder.instance_exec(&proc) if proc
      end
    end
  end
end