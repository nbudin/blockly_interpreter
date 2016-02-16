class BlocklyInterpreter::CoreBlocks::ProceduresDefReturnBlock < BlocklyInterpreter::CoreBlocks::ProcedureBlock
  self.block_type = :procedures_defreturn

  def procedure_name
    fields['NAME']
  end

  def value(execution_context)
    execution_context.execute(statements['STACK'])

    if execution_context.terminated
      execution_context.early_return_value
    else
      values['RETURN'].value(execution_context)
    end
  end

  def to_dsl
    block_contents = [
      method_call_with_block_or_nothing("body", "", statements['STACK']),
      method_call_with_block_or_nothing("return_value", "", values['RETURN'])
    ]

    method_call_with_possible_block "#{self.class.block_type}", ([procedure_name] + arg_names).map(&:inspect).join(", "), block_contents
  end

  module DSLMethods
    class ProceduresDefReturnBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      attr_reader :stack

      def initialize(block_type, procedure_name, arg_names)
        super(block_type)

        field :NAME, procedure_name

        arg_names.each do |arg_name|
          mutation_child :arg do |child|
            child['name'] = arg_name
          end
        end
      end

      def body(&proc)
        statement :STACK, &proc
      end

      def return_value(&proc)
        value :RETURN, &proc
      end
    end

    def procedures_defreturn(name, *arg_names, &proc)
      builder = BlocklyInterpreter::CoreBlocks::ProceduresDefReturnBlock::DSLMethods::ProceduresDefReturnBlockBuilder.new(
        "procedures_defreturn",
        name,
        arg_names
      )

      @blocks << builder.tap do |builder|
        builder.instance_exec(&proc) if proc
      end
    end
  end
end