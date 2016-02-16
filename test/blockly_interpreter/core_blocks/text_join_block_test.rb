require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::TextJoinBlock do
  include InterpreterTestingMethods

  it 'returns an empty string given no inputs' do
    assert_outputs('') do
      string_output do
        text_join do
        end
      end
    end
  end

  it 'returns the string given a single input' do
    assert_outputs('hello') do
      string_output do
        text_join("hello")
      end
    end
  end

  it 'returns the concatenated string given multiple inputs' do
    assert_outputs('hellohello') do
      string_output do
        text_join("hello", "hello")
      end
    end
  end

  it 'returns the concatenated string given a string and a variable' do
    assert_outputs('helloworld') do
      variables_set("str") { text "world" }

      string_output do
        text_join do
          item "hello"
          item { variables_get('str') }
        end
      end
    end
  end
end