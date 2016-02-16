require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::ComparisonOperatorBlock do
  include InterpreterTestingMethods

  it 'compares two numbers for equality' do
    assert_outputs "A" do
      controls_if do
        predicate { logic_compare :EQ, 0, 0 }
        action { string_output "A" }
      end

      controls_if do
        predicate { logic_compare :EQ, 0, 1 }
        action { string_output "B" }
      end
    end
  end

  it 'compares two numbers for inequality' do
    assert_outputs "B" do
      controls_if do
        predicate { logic_compare :NEQ, 0, 0 }
        action { string_output "A" }
      end

      controls_if do
        predicate { logic_compare :NEQ, 0, 1 }
        action { string_output "B" }
      end
    end
  end

  it 'compares two numbers for less-than-ness' do
    assert_outputs "B" do
      controls_if do
        predicate { logic_compare :LT, 1, 0 }
        action { string_output "A" }
      end

      controls_if do
        predicate { logic_compare :LT, 0, 1 }
        action { string_output "B" }
      end
    end
  end

  it 'compares two numbers for greater-than-ness' do
    assert_outputs "A" do
      controls_if do
        predicate { logic_compare :GT, 1, 0 }
        action { string_output "A" }
      end

      controls_if do
        predicate { logic_compare :GT, 0, 1 }
        action { string_output "B" }
      end
    end
  end

  it 'compares two numbers for less-than-or-equality' do
    assert_outputs "AB" do
      controls_if do
        predicate { logic_compare :LTE, 0, 0 }
        action { string_output "A" }
      end

      controls_if do
        predicate { logic_compare :LTE, 0, 1 }
        action { string_output "B" }
      end

      controls_if do
        predicate { logic_compare :LTE, 1, 0 }
        action { string_output "C" }
      end
    end
  end

  it 'compares two numbers for greater-than-or-equality' do
    assert_outputs "AC" do
      controls_if do
        predicate { logic_compare :GTE, 0, 0 }
        action { string_output "A" }
      end

      controls_if do
        predicate { logic_compare :GTE, 0, 1 }
        action { string_output "B" }
      end

      controls_if do
        predicate { logic_compare :GTE, 1, 0 }
        action { string_output "C" }
      end
    end
  end
end