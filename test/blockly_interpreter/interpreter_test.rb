require 'test_helper'

describe BlocklyInterpreter::Interpreter do
  include InterpreterTestingMethods

  it "executes a single block" do
    assert_outputs "hello world" do
      string_output "hello world"
    end
  end

  it "executes multiple statements" do
    assert_outputs "helloworld" do
      string_output "hello"
      string_output "world"
    end
  end

  describe "variable scoping" do
    it "doesn't have access to local variables from outside a procedure" do
      assert_outputs "just this" do
        procedures do
          procedures_defnoreturn "output this and set a variable" do
            variables_set(:x) { text "NOT_THIS" }
            string_output " this"
          end
        end

        string_output "just"
        procedures_callnoreturn "output this and set a variable"
        string_output { variables_get(:x) }
      end
    end

    it "does have access to global variables from inside a procedure" do
      assert_outputs "just this and that" do
        procedures do
          procedures_defnoreturn "output the variable something" do
            string_output { variables_get(:something) }
          end
        end

        string_output "just this "
        variables_set(:something) { text "and that" }
        procedures_callnoreturn "output the variable something"
      end
    end
  end
end