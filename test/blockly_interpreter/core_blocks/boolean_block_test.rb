require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::BooleanBlock do
  include InterpreterTestingMethods

  it 'returns true' do
    assert_outputs('true') do
      string_output { logic_boolean true }
    end
  end

  it 'returns false' do
    assert_outputs('false') do
      string_output { logic_boolean false }
    end
  end
end