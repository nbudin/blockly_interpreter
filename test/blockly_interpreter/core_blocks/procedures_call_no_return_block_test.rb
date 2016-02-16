require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::ProceduresCallNoReturnBlock do
  include InterpreterTestingMethods

  it "calls a procedure with no return and no parameters" do
    assert_outputs "hello" do
      procedures do
        procedures_defnoreturn "output hello" do
          string_output "hello"
        end
      end

      procedures_callnoreturn "output hello"
    end
  end

  it "calls a procedure with no return and parameters" do
    assert_outputs "hello world" do
      procedures do
        procedures_defnoreturn "output two strings", :a, :b do
          string_output { variables_get(:a) }
          string_output { variables_get(:b) }
        end
      end

      procedures_callnoreturn "output two strings" do
        arg(:a) { text "hello" }
        arg(:b) { text " world" }
      end
    end
  end
end