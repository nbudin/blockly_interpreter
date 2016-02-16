require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::ForEachBlock do
  include InterpreterTestingMethods

  it 'loops through an array' do
    assert_outputs "a b c " do
      for_each('str') do
        list do
          lists_create_with do
            item { text 'a' }
            item { text 'b' }
            item { text 'c' }
          end
        end

        action do
          string_output { variables_get "str" }
          string_output " "
        end
      end
    end
  end
end