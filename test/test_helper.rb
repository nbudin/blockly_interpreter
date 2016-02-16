$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'blockly_interpreter'
require 'blockly_interpreter/extension_blocks'

BlocklyInterpreter::ExtensionBlocks.register!

require 'minitest/spec'
require 'minitest/reporters'
require 'minitest/autorun'

Minitest::Reporters.use!

require 'timecop'
require 'pry'

class OutputStringBlock < BlocklyInterpreter::Block
  self.block_type = :string_output

  def execute_statement(execution_context)
    execution_context.add_content(values['VALUE'].value(execution_context).to_s)
  end

  module DSLMethods
    def string_output(content = nil, &proc)
      block :string_output do
        value :VALUE do
          if block_given?
            instance_exec &proc
          else
            text content
          end
        end
      end
    end
  end
end

class RaiseExceptionBlock < BlocklyInterpreter::Block
  class TestException < RuntimeError
  end

  self.block_type = :raise_exception

  def value(execution_context)
    raise TestException
  end

  def execute_statement(execution_context)
    raise TestException
  end

  module DSLMethods
    def raise_exception
      block :raise_exception
    end
  end
end

class TestInterpreter < BlocklyInterpreter::Interpreter
  class ExecutionContext < BlocklyInterpreter::ExecutionContext
    attr_reader :content

    def initialize(interpreter)
      super(interpreter)
      @content = ""
    end

    def add_content(str)
      @content << str
    end

    def merge_state_from(context)
      add_content(context.content)
    end
  end

  def content
    execute.content
  end

  def build_execution_context
    TestInterpreter::ExecutionContext.new(self)
  end
end

module InterpreterTestingMethods
  def self.included(mod)
    mod.let(:parser) { BlocklyInterpreter::Parser.new }
  end

  def assert_outputs(value, &block)
    xml = BlocklyInterpreter::DSL.build_xml(&block)
    program = parser.parse(xml)
    TestInterpreter.new(program).content.must_equal value
  end
end

[OutputStringBlock, RaiseExceptionBlock].each do |klass|
  BlocklyInterpreter::Parser.register_block_class klass
  BlocklyInterpreter::DSL::BlockContext.register_block_class klass
end