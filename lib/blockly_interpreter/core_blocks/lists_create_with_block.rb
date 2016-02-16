class BlocklyInterpreter::CoreBlocks::ListsCreateWithBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = :lists_create_with

  def item_count
    @item_count ||= mutation.try(:[], 'items').try(:to_i) || 0
  end

  def items
    @items ||= (0...item_count).map do |i|
      values["ADD#{i}"]
    end.compact
  end

  def value(execution_context)
    items.map { |item| item.value(execution_context) }
  end

  def to_dsl
    item_dsls = items.map { |item| method_call_with_possible_block("item", "", item) }
    method_call_with_possible_block("lists_create_with", "", item_dsls)
  end

  module DSLMethods
    class ListsCreateWithBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      def initialize(block_type)
        super
        @item_number = 0
      end

      def item(&proc)
        value("ADD#{@item_number}", &proc)
        @item_number += 1
      end

      def to_xml(node)
        mutation_attr("items", @item_number)
        super
      end
    end

    def lists_create_with(&proc)
      @blocks << BlocklyInterpreter::CoreBlocks::ListsCreateWithBlock::DSLMethods::ListsCreateWithBlockBuilder.new('lists_create_with').tap do |builder|
        builder.instance_exec(&proc)
      end
    end
  end
end