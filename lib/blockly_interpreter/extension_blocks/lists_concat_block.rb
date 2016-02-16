class BlocklyInterpreter::ExtensionBlocks::ListsConcatBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = :lists_concat

  def value(execution_context)
    list(execution_context, 1) + list(execution_context, 2)
  end

  def list(execution_context, n)
    values["LIST#{n}"].try!(:value, execution_context) || []
  end

  def to_dsl
    method_call_with_possible_block("lists_concat", "", [
      method_call_with_block_or_nothing("list1", "", values['LIST1']),
      method_call_with_block_or_nothing("list2", "", values['LIST2'])
    ])
  end

  module DSLMethods
    class ListsConcatBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      def list1(&proc)
        value("LIST1", &proc)
      end

      def list2(&proc)
        value("LIST2", &proc)
      end
    end

    def lists_concat
      @blocks << BlocklyInterpreter::ExtensionBlocks::ListsConcatBlock::DSLMethods::ListsConcatBlockBuilder.new('lists_concat').tap do |builder|
        builder.instance_exec(&proc) if proc
      end
    end
  end
end