require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::SetVariableBlock do
  include InterpreterTestingMethods

  it 'responds correctly to variable sets and resets' do
    assert_outputs "right" do
      variables_set(:item) { logic_boolean false }
      controls_if do
        predicate { variables_get :item }
        action { string_output "wrong" }
      end

      variables_set(:item) { logic_boolean true }
      controls_if do
        predicate { variables_get :item }
        action { string_output "right" }
      end
    end
  end
end