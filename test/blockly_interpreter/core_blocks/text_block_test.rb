require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::TextBlock do
  include InterpreterTestingMethods

  it 'returns a string' do
    assert_outputs('some string') do
      string_output { text 'some string' }
    end
  end
end