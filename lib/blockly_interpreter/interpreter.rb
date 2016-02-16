require 'nokogiri'

class BlocklyInterpreter::Interpreter
  attr_reader :program, :debug_messages

  def initialize(program)
    @program = program
    @debug_messages = []
  end

  def build_execution_context
    BlocklyInterpreter::ExecutionContext.new(self)
  end

  def execute
    build_execution_context.tap do |context|
      context.execute(program.first_block)
      add_debug_messages context.debug_messages
    end
  end

  def add_debug_messages(debug_messages)
    @debug_messages.push *debug_messages
  end
end