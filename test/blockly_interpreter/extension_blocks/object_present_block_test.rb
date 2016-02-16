require 'test_helper'

describe BlocklyInterpreter::ExtensionBlocks::ObjectPresentBlock do
  include InterpreterTestingMethods

  it "returns true for a present value" do
    assert_outputs('true') do
      string_output do
        object_present { text "something" }
      end
    end
  end

  it "returns false for a whitespace value" do
    assert_outputs('false') do
      string_output do
        object_present { text " \t\n" }
      end
    end
  end

  it "returns false for an empty list" do
    assert_outputs('false') do
      string_output do
        object_present { lists_create_with {} }
      end
    end
  end

  it "returns false for a null value" do
    assert_outputs('false') do
      string_output do
        block 'object_present'
      end
    end
  end
end