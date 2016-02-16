class BlocklyInterpreter::CoreBlocks::ForBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = 'controls_for'

  def execute_statement(execution_context)
    from = values['FROM'].value(execution_context).to_i
    to = values['TO'].value(execution_context).to_i
    by = values['BY'].value(execution_context).to_i

    from.step(by: by, to: to) do |i|
      execution_context.set_variable(fields['VAR'], i)
      execution_context.execute(statements['DO'])
    end
  end

  def to_dsl
    method_call_with_possible_block('controls_for', fields['VAR'].inspect, [
      method_call_with_block_or_nothing('from', '', values['FROM']),
      method_call_with_block_or_nothing('to', '', values['TO']),
      method_call_with_block_or_nothing('by', '', values['BY']),
      method_call_with_block_or_nothing('action', '', statements['DO'])
    ])
  end

  module DSLMethods
    class ForBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      def initialize(block_type, var_name)
        super(block_type)
        field :VAR, var_name
        by(1)
      end

      def from(val = nil, &proc)
        proc ||= Proc.new { math_number val }
        value "FROM", &proc
      end

      def to(val = nil, &proc)
        proc ||= Proc.new { math_number val }
        value "TO", &proc
      end

      def by(val = nil, &proc)
        proc ||= Proc.new { math_number val }
        @by_proc = proc
      end

      def action(&proc)
        statement "DO", &proc
      end

      def to_xml(node)
        value "BY", &@by_proc
        super
      end
    end

    def controls_for(var_name, from = nil, to = nil, by = nil, &proc)
      @blocks << BlocklyInterpreter::CoreBlocks::ForBlock::DSLMethods::ForBlockBuilder.new("controls_for", var_name).tap do |builder|
        builder.from(from) if from
        builder.to(to) if to
        builder.by(by) if by

        builder.instance_exec(&proc)
      end
    end
  end
end