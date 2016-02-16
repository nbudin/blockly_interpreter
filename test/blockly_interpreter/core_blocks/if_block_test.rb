require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::IfBlock do
  include InterpreterTestingMethods

  it "evaluates a basic if conditional" do
    assert_outputs "red" do
      controls_if do
        predicate { logic_boolean true }
        action { string_output "red" }
      end
    end
  end

  it "goes to an else-if clause correctly" do
    assert_outputs "blue" do
      controls_if do
        predicate { logic_boolean false }
        action { string_output "red" }

        elsif_clause do
          predicate { logic_boolean true }
          action { string_output "blue" }
        end
      end
    end
  end

  it "goes to a second else-if clause correctly" do
    assert_outputs "green" do
      controls_if do
        predicate { logic_boolean false }
        action { string_output "red" }

        elsif_clause do
          predicate { logic_boolean false }
          action { string_output "blue" }
        end

        elsif_clause do
          predicate { logic_boolean true }
          action { string_output "green" }
        end
      end
    end
  end

  it "goes to an else clause correctly" do
    assert_outputs "yellow" do
      controls_if do
        predicate { logic_boolean false }
        action { string_output "red" }

        elsif_clause do
          predicate { logic_boolean false }
          action { string_output "blue" }
        end

        elsif_clause do
          predicate { logic_boolean false }
          action { string_output "green" }
        end

        else_action { string_output "yellow" }
      end
    end
  end
end