class BlocklyInterpreter::CoreBlocks::TextJoinBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = :text_join

  def item_count
    @item_count ||= mutation.try(:[], 'items').try(:to_i) || 0
  end

  def value(execution_context)
    (0...item_count).map { |i| values["ADD#{i}"].value(execution_context) }.join
  end

  def to_dsl
    item_dsls = (0...item_count).map do |i|
      method_call_with_block_or_nothing("item", "", values["ADD#{i}"])
    end.compact

    method_call_with_possible_block("text_join", "", item_dsls)
  end

  module DSLMethods
    class TextJoinBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      def initialize(block_type)
        super
        @item_number = 0
      end

      def item(string = nil, &proc)
        proc ||= Proc.new { text string }
        value("ADD#{@item_number}", &proc)
        @item_number += 1
      end

      def to_xml(node)
        mutation_attr("items", @item_number)
        super
      end
    end

    def text_join(*strings, &proc)
      @blocks << BlocklyInterpreter::CoreBlocks::TextJoinBlock::DSLMethods::TextJoinBlockBuilder.new('text_join').tap do |builder|
        strings.each do |string|
          builder.item string
        end

        builder.instance_exec(&proc) if proc
      end
    end
  end
end