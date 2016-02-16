class BlocklyInterpreter::CoreBlocks::RepeatTimesBlock < BlocklyInterpreter::Block
  self.block_type = :controls_repeat_ext

  def execute_statement(execution_context)
    n = values['TIMES'].value(execution_context).to_i
    n.times { execution_context.execute(statements['DO']) }
  end

  module DSLMethods
    class RepeatBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      def times(&proc)
        value "TIMES", &proc
      end

      def action(&proc)
        statement "DO", &proc
      end
    end

    def controls_repeat_ext(&proc)
      @blocks << BlocklyInterpreter::CoreBlocks::RepeatTimesBlock::DSLMethods::RepeatBlockBuilder.new("controls_repeat_ext").tap do |builder|
        builder.instance_exec(&proc)
      end
    end

    def repeat_times(n, &proc)
      controls_repeat_ext do
        times { math_number n }
        action &proc
      end
    end
  end
end