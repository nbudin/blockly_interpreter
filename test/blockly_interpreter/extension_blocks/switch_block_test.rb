require 'test_helper'

describe BlocklyInterpreter::ExtensionBlocks::SwitchBlock do
  include InterpreterTestingMethods

  it "evaluates a basic equality switch" do
    assert_outputs "red" do
      controls_switch do
        switch_value { text "abc" }
        predicate { text "abc" }
        action { string_output "red" }
      end
    end
  end

  it "goes to an else-if clause correctly" do
    assert_outputs "blue" do
      controls_switch do
        switch_value { text "abc" }

        predicate { text "xyz" }
        action { string_output "red" }

        predicate { text "abc" }
        action { string_output "blue" }
      end
    end
  end

  it "goes to a second else-if clause correctly" do
    assert_outputs "green" do
      controls_switch do
        switch_value { text "abc" }

        predicate { text "xyz" }
        action { string_output "red" }

        predicate { text "ghi" }
        action { string_output "blue" }

        predicate { text "abc" }
        action { string_output "green" }
      end
    end
  end

  it "goes to an else clause correctly" do
    assert_outputs "yellow" do
      controls_switch do
        switch_value { text "123" }

        predicate { text "xyz" }
        action { string_output "red" }

        predicate { text "ghi" }
        action { string_output "blue" }

        predicate { text "abc" }
        action { string_output "green" }

        else_action { string_output "yellow" }
      end
    end
  end

  it "captures the value" do
    assert_outputs "123" do
      controls_switch do
        switch_value { text "123" }
        capture_as 'doggie'

        predicate { text "xyz" }
        action { string_output "red" }

        predicate { text "ghi" }
        action { string_output "blue" }

        predicate { text "abc" }
        action { string_output "green" }

        else_action do
          string_output { variables_get('doggie') }
        end
      end
    end
  end
end