class BlocklyInterpreter::CoreBlocks::ForEachBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = 'controls_forEach'

  def execute_statement(execution_context)
    list = values['LIST'].value(execution_context)
    list.each do |item|
      execution_context.set_variable(fields['VAR'], item)
      execution_context.execute(statements['DO'])
    end
  end

  def to_dsl
    method_call_with_possible_block("for_each", fields['VAR'].inspect, [
      method_call_with_block_or_nothing("list", "", values['LIST']),
      method_call_with_block_or_nothing("action", "", statements['DO'])
    ].compact)
  end

  module DSLMethods
    class ForEachBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      def initialize(block_type, var_name)
        super(block_type)
        field :VAR, var_name
      end

      def list(&proc)
        value "LIST", &proc
      end

      def action(&proc)
        statement "DO", &proc
      end
    end

    def for_each(var_name, &proc)
      @blocks << BlocklyInterpreter::CoreBlocks::ForEachBlock::DSLMethods::ForEachBlockBuilder.new("controls_forEach", var_name).tap do |builder|
        builder.instance_exec(&proc)
      end
    end
  end
end