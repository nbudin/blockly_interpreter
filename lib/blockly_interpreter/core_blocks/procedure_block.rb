class BlocklyInterpreter::CoreBlocks::ProcedureBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator

  def arg_hash(parameters)
    Hash[arg_names.zip(parameters)]
  end

  def arg_names
    @arg_names ||= (mutation && mutation.css('> arg').map { |arg| arg['name'] }) || []
  end

  def arg_values(execution_context)
    (0...arg_names.size).map do |arg_num|
      values["ARG#{arg_num}"].value(execution_context)
    end
  end

  def args_dsl
    arg_names.each_with_index.map do |arg_name, i|
      method_call_with_possible_block("arg", arg_name.inspect, values["ARG#{i}"])
    end.compact
  end

  def to_dsl
    method_call_with_possible_block "#{self.class.block_type}", procedure_name.inspect, args_dsl
  end

  module DSLMethods
    class ProcedureCallBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      attr_reader :arg_number

      def initialize(block_type, procedure_name)
        super(block_type)

        mutation_attr :name, procedure_name
        @arg_number = 0
      end

      def arg(name, &proc)
        mutation_child :arg do |child|
          child['name'] = name
        end

        value "ARG#{arg_number}", &proc
        @arg_number += 1
      end
    end
  end
end