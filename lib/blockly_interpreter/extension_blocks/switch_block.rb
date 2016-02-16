class BlocklyInterpreter::ExtensionBlocks::SwitchBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = :controls_switch

  class Conditional
    attr_reader :predicate_block, :action_block

    def initialize(switch_block, num)
      @predicate_block = switch_block.values["CASE#{num}"]
      @action_block = switch_block.statements["DO#{num}"]
    end

    def matches?(value, execution_context)
      predicate_block.value(execution_context) == value
    end

    def execute_statement(execution_context)
      execution_context.execute(action_block)
    end
  end

  def predicates
    @predicates ||= begin
      case_count = mutation.try(:[], 'case').try(:to_i) || 0
      (0...case_count).map { |num| Conditional.new(self, num) }
    end
  end

  def else_block
    statements['ELSE']
  end

  def execute_statement(execution_context)
    (matching_predicate(execution_context) || else_block).try!(:execute_statement, execution_context)
  end

  def matching_predicate(execution_context)
    val = switch_value(execution_context)
    execution_context.set_variable(fields['CAPTURE_VAR'], val) if fields['CAPTURE_VAR'].present?
    predicates.detect { |predicate| predicate.matches? val, execution_context }
  end

  def switch_value(execution_context)
    values['SWITCH_VAL'].value(execution_context)
  end

  def to_dsl
    preamble_dsl = [method_call_with_possible_block('switch_value', '', values['SWITCH_VAL'])]
    preamble_dsl << "capture_as #{fields['CAPTURE_VAR'].inspect}" if fields['CAPTURE_VAR'].present?

    clauses_dsl = predicates.map do |predicate|
      [
        method_call_with_possible_block('predicate', '', predicate.predicate_block),
        method_call_with_possible_block('action', '', predicate.action_block)
      ].join("\n")
    end

    clauses_dsl << method_call_with_block_or_nothing('else_action', '', statements['ELSE'])

    method_call_with_possible_block('controls_switch', '', [preamble_dsl.join("\n"), clauses_dsl.join("\n")].join("\n"))
  end

  module DSLMethods
    class SwitchBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      attr_reader :predicate_number

      def initialize(block_type)
        super
        @predicate_number = 0
      end

      def capture_as(var_name)
        field "CAPTURE_VAR", var_name
        mutation_attr('capture', 1)
      end

      def switch_value(&proc)
        value "SWITCH_VAL", &proc
      end

      def predicate(&proc)
        value "CASE#{predicate_number}", &proc
      end

      def action(&proc)
        statement "DO#{predicate_number}", &proc
        @predicate_number += 1
      end

      def else_action(&proc)
        mutation_attr "else", 1
        statement "ELSE", &proc
      end

      def to_xml(node)
        mutation_attr("case", @predicate_number) if @predicate_number > 0
        super
      end
    end

    def controls_switch(&proc)
      @blocks << BlocklyInterpreter::ExtensionBlocks::SwitchBlock::DSLMethods::SwitchBlockBuilder.new("controls_switch").tap do |builder|
        builder.instance_exec(&proc)
      end
    end
  end
end