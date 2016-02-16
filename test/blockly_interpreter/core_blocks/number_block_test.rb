require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::NumberBlock do
  include InterpreterTestingMethods

  it 'returns an integer' do
    assert_outputs('666') do
      string_output { math_number 666 }
    end
  end

  it 'returns a negative integer' do
    assert_outputs('-42') do
      string_output { math_number -42 }
    end
  end
end