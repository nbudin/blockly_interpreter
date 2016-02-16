require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::ForBlock do
  include InterpreterTestingMethods

  it 'loops from start to finish' do
    assert_outputs "3 4 5 " do
      controls_for('i', 3, 5) do
        action do
          string_output { variables_get "i" }
          string_output " "
        end
      end
    end
  end

  it 'loops with a negative step value' do
    assert_outputs "10 9 8 " do
      controls_for('i', 10, 8, -1) do
        action do
          string_output { variables_get "i" }
          string_output " "
        end
      end
    end
  end

  it 'loops with a greater-than-1 step value' do
    assert_outputs "2 4 6 8 10 " do
      controls_for('i', 2, 10, 2) do
        action do
          string_output { variables_get "i" }
          string_output " "
        end
      end
    end
  end

  it 'loops based on dynamic values' do
    assert_outputs "1 2 3 4 5 " do
      variables_set("from") { math_number 1 }
      variables_set("to") { math_number 5 }
      variables_set("by") { math_number 1 }

      controls_for('i') do
        from { variables_get("from") }
        to { variables_get("to") }
        by { variables_get("by") }

        action do
          string_output { variables_get "i" }
          string_output " "
        end
      end
    end
  end
end