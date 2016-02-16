class BlocklyInterpreter::CoreBlocks::ListsGetIndexBlock < BlocklyInterpreter::Block
  include BlocklyInterpreter::DSLGenerator
  self.block_type = :lists_getIndex

  def is_statement?
    mutation.try(:[], 'statement') == 'true'
  end

  def execute_statement(execution_context)
    return unless is_statement?
    value(execution_context)
  end

  def value(execution_context)
    list = values['VALUE'].value(execution_context)
    list_index = index(execution_context, list)

    value_at_index = list[list_index]
    list.delete_at(list_index) if %w(GET_REMOVE REMOVE).include?(fields['MODE'])
    value_at_index
  end

  def to_dsl
    case fields['WHERE']
    when 'FIRST', 'LAST', 'RANDOM'
      method_call_with_possible_block("lists_get_#{fields['WHERE'].downcase}", "", values['VALUE'])
    else
      block_contents = [
        method_call_with_block_or_nothing('at', '', values['AT']),
        method_call_with_block_or_nothing('list', '', values['VALUE'])
      ].compact

      method_call_with_possible_block("lists_get_index", "mode: #{fields["MODE"].inspect}, where: #{fields["WHERE"].inspect}", block_contents)
    end
  end

  module DSLMethods
    class ListsGetIndexBlockBuilder < BlocklyInterpreter::DSL::BlockBuilder
      def at(index = nil, &proc)
        proc ||= Proc.new { math_number index }
        @has_at = true
        value 'AT', &proc
      end

      def list(&proc)
        value 'VALUE', &proc
      end

      def to_xml(node)
        mutation_attr('statement', (@fields["MODE"] == 'REMOVE').to_s)
        mutation_attr('at', (!!@has_at).to_s)
        super
      end
    end

    def lists_get_first(&proc)
      lists_get_index where: 'FIRST' do
        list &proc
      end
    end

    def lists_get_last(&proc)
      lists_get_index where: 'LAST' do
        list &proc
      end
    end

    def lists_get_random(&proc)
      lists_get_index where: 'RANDOM' do
        list &proc
      end
    end

    def lists_get_index(mode: 'GET', where: 'FROM_START', &proc)
      @blocks << BlocklyInterpreter::CoreBlocks::ListsGetIndexBlock::DSLMethods::ListsGetIndexBlockBuilder.new("lists_getIndex").tap do |builder|
        builder.field 'MODE', mode
        builder.field 'WHERE', where
        builder.instance_exec(&proc)
      end
    end
  end

  private
  def index(execution_context, list)
    case fields['WHERE']
    when 'FIRST' then 0
    when 'LAST' then list.size - 1
    when 'FROM_START' then values['AT'].value(execution_context) - 1
    when 'FROM_END' then list.size - values['AT'].value(execution_context)
    when 'RANDOM' then rand(list.size)
    end
  end
end