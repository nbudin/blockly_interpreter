class BlocklyInterpreter::ExtensionBlocks::ListsAppendBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = :lists_append

  def execute_statement(execution_context)
    list = values['LIST'].value(execution_context)
    list << values['VALUE'].value(execution_context)
  end

  def to_dsl
    method_call_with_possible_block('lists_append', '', [
      method_call_with_block_or_nothing('list', '', values['LIST']),
      method_call_with_block_or_nothing('item', '', values['VALUE'])
    ])
  end

  module DSLMethods
    class ListsAppendBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      def list(&proc)
        value("LIST", &proc)
      end

      def item(&proc)
        value("VALUE", &proc)
      end
    end

    def lists_append
      @blocks << BlocklyInterpreter::ExtensionBlocks::ListsAppendBlock::DSLMethods::ListsAppendBlockBuilder.new('lists_append').tap do |builder|
        builder.instance_exec(&proc) if proc
      end
    end
  end
end