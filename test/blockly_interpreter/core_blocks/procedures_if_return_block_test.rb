require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::ProceduresIfReturnBlock do
  include InterpreterTestingMethods

  it "allows early return with no value from procedures" do
    assert_outputs "..N" do
      procedures do
        procedures_defnoreturn "check equality", :a, :b do
          string_output "."

          procedures_ifreturn do
            condition do
              logic_compare :EQ do
                a { variables_get :a }
                b { variables_get :b }
              end
            end
          end

          string_output "N"
        end
      end

      procedures_callnoreturn "check equality" do
        arg(:a) { math_number 1 }
        arg(:b) { math_number 1 }
      end

      procedures_callnoreturn "check equality" do
        arg(:a) { math_number 1 }
        arg(:b) { math_number 3 }
      end
    end
  end

  it "allows early return with value from procedures" do
    assert_outputs "YN" do
      procedures do
        procedures_defreturn "check equality", :a, :b do
          body do
            procedures_ifreturn do
              condition do
                logic_compare :EQ do
                  a { variables_get :a }
                  b { variables_get :b }
                end
              end

              return_value { text "Y" }
            end
          end

          return_value { text "N" }
        end
      end

      string_output do
        procedures_callreturn "check equality" do
          arg(:a) { math_number 1 }
          arg(:b) { math_number 1 }
        end
      end

      string_output do
        procedures_callreturn "check equality" do
          arg(:a) { math_number 1 }
          arg(:b) { math_number 3 }
        end
      end
    end
  end
end