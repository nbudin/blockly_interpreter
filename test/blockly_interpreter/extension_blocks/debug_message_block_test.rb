require 'test_helper'

describe BlocklyInterpreter::ExtensionBlocks::DebugMessageBlock do
  include InterpreterTestingMethods

  def assert_debug_messages_equal(debug_messages, &proc)
    xml = BlocklyInterpreter::DSL.build_xml(&proc)

    program = parser.parse(xml)
    interpreter = TestInterpreter.new(program)
    interpreter.content.must_equal ''
    interpreter.debug_messages.must_equal debug_messages
  end

  it "logs a debug message" do
    assert_debug_messages_equal(["Debug!"]) do
      debug_message "Debug!"
    end
  end

  it "logs multiple debug messages" do
    assert_debug_messages_equal(["Debug!", "Debug?"]) do
      debug_message "Debug!"
      debug_message "Debug?"
    end
  end
end