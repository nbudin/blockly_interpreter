require 'test_helper'

describe BlocklyInterpreter::ExtensionBlocks::ListsAppendBlock do
  include InterpreterTestingMethods

  it "adds something onto an existing list" do
    assert_outputs('["a thing", "another thing"]') do
      variables_set('list') do
        lists_create_with do
          item { text 'a thing' }
        end
      end

      lists_append do
        list { variables_get('list') }
        item { text 'another thing' }
      end

      string_output { variables_get('list') }
    end
  end
end