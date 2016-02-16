require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::ProceduresCallReturnBlock do
  include InterpreterTestingMethods

  it "calls a procedure with a return and no parameters" do
    assert_outputs "hello" do
      procedures do
        procedures_defreturn "return hello" do
          return_value { text "hello" }
        end
      end

      string_output { procedures_callreturn "return hello" }
    end
  end

  it "calls a procedure with a return and parameters" do
    assert_outputs "10" do
      procedures do
        procedures_defreturn "add two numbers", :a, :b do
          body do
            variables_set(:sum) do
              math_arithmetic(:add) do
                a { variables_get(:a) }
                b { variables_get(:b) }
              end
            end
          end

          return_value do
            variables_get(:sum)
          end
        end
      end

      string_output do
        procedures_callreturn "add two numbers" do
          arg(:a) { math_number 8 }
          arg(:b) { math_number 2 }
        end
      end
    end
  end
end