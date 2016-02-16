class BlocklyInterpreter::CoreBlocks::IfBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = :controls_if

  class Conditional
    attr_reader :predicate_block, :action_block

    def initialize(if_block, num)
      @predicate_block = if_block.values["IF#{num}"]
      @action_block = if_block.statements["DO#{num}"]
    end

    def matches?(execution_context)
      predicate_block.value(execution_context).present?
    end

    def execute_statements(execution_context)
      execution_context.execute(action_block)
    end
  end

  def predicates
    @predicates ||= begin
      (0..elseif_count).map { |num| Conditional.new(self, num) }
    end
  end

  def elseif_count
    @elseif_count ||= mutation.try(:[], 'elseif').try(:to_i) || 0
  end

  def else_block
    statements['ELSE']
  end

  def execute_statement(execution_context)
    match = matching_predicate(execution_context)

    if match
      match.execute_statements(execution_context)
    elsif else_block
      execution_context.execute(else_block)
    end
  end

  def matching_predicate(execution_context)
    predicates.detect { |predicate| predicate.matches? execution_context }
  end

  def predicate_action_dsl(num)
    [
      method_call_with_possible_block("predicate", "", values["IF#{num}"]),
      method_call_with_possible_block("action", "", statements["DO#{num}"])
    ]
  end

  def to_dsl
    block_contents = predicate_action_dsl(0) + (1..elseif_count).flat_map do |num|
      method_call_with_possible_block("elsif_clause", "", predicate_action_dsl(num))
    end
    block_contents << method_call_with_block_or_nothing("else_action", "", else_block)

    method_call_with_block_or_nothing("controls_if", "", block_contents.compact)
  end

  module DSLMethods
    class IfBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      attr_reader :predicate_number

      def initialize(block_type)
        super
        @predicate_number = 0
      end

      def predicate(&proc)
        value "IF#{predicate_number}", &proc
      end

      def action(&proc)
        statement "DO#{predicate_number}", &proc
      end

      def elsif_clause(&proc)
        @predicate_number += 1
        instance_exec(&proc)
      end

      def else_action(&proc)
        mutation_attr "else", 1
        statement "ELSE", &proc
      end

      def to_xml(node)
        mutation_attr("elseif", @predicate_number) if @predicate_number > 0
        super
      end
    end

    def controls_if(&proc)
      @blocks << BlocklyInterpreter::CoreBlocks::IfBlock::DSLMethods::IfBlockBuilder.new("controls_if").tap do |builder|
        builder.instance_exec(&proc)
      end
    end
  end
end