class BlocklyInterpreter::ExtensionBlocks::ListsIncludeOperatorBlock < BlocklyInterpreter::Block
  self.block_type = :lists_include

  def value(execution_context)
    a = values['A'].value(execution_context)
    b = values['B'].value(execution_context)

    case fields['OP']
    when 'INCLUDE' then a.try(:include?, b)
    when 'NINCLUDE' then !a.try(:include?, b)
    end
  end

  class DSLGenerator < BlocklyInterpreter::DSL::BinaryOperationDSLGenerator
    def initialize(block)
      super(block, nil)
    end

    def dsl_method_name
      case block.fields['OP']
      when 'INCLUDE' then "lists_include"
      when 'NINCLUDE' then "lists_not_include"
      end
    end

    def method_args
      args = super
      args.slice(1, args.size - 1)
    end
  end

  def to_dsl
    DSLGenerator.new(self).dsl
  end

  module DSLMethods
    class ListIncludesBlockBuilder < BlocklyInterpreter::DSL::BinaryOperationBlockBuilder
    end

    def lists_include(a = nil, b = nil, &proc)
      @blocks << BlocklyInterpreter::ExtensionBlocks::ListsIncludeOperatorBlock::DSLMethods::ListIncludesBlockBuilder.new('lists_include', "INCLUDE", a, b).tap do |builder|
        builder.instance_exec(&proc) if proc
      end
    end

    def lists_not_include(a = nil, b = nil, &proc)
      @blocks << BlocklyInterpreter::ExtensionBlocks::ListsIncludeOperatorBlock::DSLMethods::ListIncludesBlockBuilder.new('lists_include', "NINCLUDE", a, b).tap do |builder|
        builder.instance_exec(&proc) if proc
      end
    end
  end
end