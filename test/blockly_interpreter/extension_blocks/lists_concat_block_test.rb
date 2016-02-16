require 'test_helper'

describe BlocklyInterpreter::ExtensionBlocks::ListsConcatBlock do
  include InterpreterTestingMethods

  it "adds something onto an existing list" do
    assert_outputs('["a thing", "another thing"]') do
      string_output do
        lists_concat do
          list1 do
            lists_create_with do
              item { text 'a thing' }
            end
          end

          list2 do
            lists_create_with do
              item { text 'another thing' }
            end
          end
        end
      end
    end
  end
end