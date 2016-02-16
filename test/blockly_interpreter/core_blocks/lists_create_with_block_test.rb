require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::ListsCreateWithBlock do
  include InterpreterTestingMethods

  it 'creates an empty list' do
    assert_outputs "[]" do
      string_output do
        lists_create_with do
        end
      end
    end
  end

  it 'creates a list with one item' do
    assert_outputs "[6]" do
      string_output do
        lists_create_with do
          item { math_number 6 }
        end
      end
    end
  end

  it 'creates a list with multiple items' do
    assert_outputs "[5, 6, 7, 8]" do
      string_output do
        lists_create_with do
          item { math_number 5 }
          item { math_number 6 }
          item { math_number 7 }
          item { math_number 8 }
        end
      end
    end
  end
end