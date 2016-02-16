require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::LogicalOperatorBlock do
  include InterpreterTestingMethods

  it 'does an AND operation' do
    assert_outputs "A" do
      controls_if do
        predicate { logic_operation :AND, true, true }
        action { string_output "A" }
      end

      controls_if do
        predicate { logic_operation :AND, true, false }
        action { string_output "B" }
      end

      controls_if do
        predicate { logic_operation :AND, false, true }
        action { string_output "C" }
      end

      controls_if do
        predicate { logic_operation :AND, false, false }
        action { string_output "D" }
      end
    end
  end

  it 'evaluates AND as a short-circuit operation' do
    assert_outputs "OK" do
      controls_if do
        predicate do
          logic_operation :AND do
            a { logic_boolean false }
            b { raise_exception }
          end
        end

        action { string_output "NOT OK" }
      end

      string_output "OK"
    end

    assert_raises(RaiseExceptionBlock::TestException) do
      assert_outputs "NOT OK" do
        controls_if do
          predicate do
            logic_operation :AND do
              a { logic_boolean true }
              b { raise_exception }
            end
          end

          action { string_output "NOT OK" }
        end

        string_output "OK"
      end
    end
  end

  it 'does an OR operation' do
    assert_outputs "ABC" do
      controls_if do
        predicate { logic_operation :OR, true, true }
        action { string_output "A" }
      end

      controls_if do
        predicate { logic_operation :OR, true, false }
        action { string_output "B" }
      end

      controls_if do
        predicate { logic_operation :OR, false, true }
        action { string_output "C" }
      end

      controls_if do
        predicate { logic_operation :OR, false, false }
        action { string_output "D" }
      end
    end
  end

  it 'evaluates OR as a short-circuit operation' do
    assert_outputs "EXEC OK" do
      controls_if do
        predicate do
          logic_operation :OR do
            a { logic_boolean true }
            b { raise_exception }
          end
        end

        action { string_output "EXEC " }
      end

      string_output "OK"
    end

    assert_raises(RaiseExceptionBlock::TestException) do
      assert_outputs "NOT OK" do
        controls_if do
          predicate do
            logic_operation :OR do
              a { logic_boolean false }
              b { raise_exception }
            end
          end

          action { string_output "NOT OK" }
        end

        string_output "OK"
      end
    end
  end
end