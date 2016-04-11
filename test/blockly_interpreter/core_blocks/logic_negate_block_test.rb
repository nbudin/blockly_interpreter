require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::LogicNegateBlock do
  include InterpreterTestingMethods

  it 'negates true' do
    assert_outputs 'false' do
      string_output do
        logic_negate { logic_boolean true }
      end
    end
  end

  it 'negates false' do
    assert_outputs 'true' do
      string_output do
        logic_negate { logic_boolean false }
      end
    end
  end
end