require 'test_helper'

describe BlocklyInterpreter::ExtensionBlocks::ListsIncludeOperatorBlock do
  include InterpreterTestingMethods

  it "returns true if a list includes something" do
    assert_outputs("true") do
      string_output do
        lists_include do
          a do
            lists_create_with do
              item { text "cow" }
              item { text "chicken" }
              item { text "horse" }
            end
          end

          b { text "horse" }
        end
      end
    end
  end

  it "returns false if a list doesn't include something" do
    assert_outputs("false") do
      string_output do
        lists_include do
          a do
            lists_create_with do
              item { text "cow" }
              item { text "chicken" }
              item { text "horse" }
            end
          end

          b { text "butterfly" }
        end
      end
    end
  end

  it "returns true if a list not-includes something" do
    assert_outputs("true") do
      string_output do
        lists_not_include do
          a do
            lists_create_with do
              item { text "cow" }
              item { text "chicken" }
              item { text "horse" }
            end
          end

          b { text "llama" }
        end
      end
    end
  end

  it "returns false if a list doesn't not-include something" do
    assert_outputs("false") do
      string_output do
        lists_not_include do
          a do
            lists_create_with do
              item { text "cow" }
              item { text "chicken" }
              item { text "horse" }
            end
          end

          b { text "chicken" }
        end
      end
    end
  end
end