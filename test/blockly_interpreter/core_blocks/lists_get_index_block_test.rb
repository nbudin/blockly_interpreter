require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::ListsGetIndexBlock do
  include InterpreterTestingMethods

  it 'gets the first item from a list' do
    assert_outputs "5" do
      variables_set('list') do
        lists_create_with do
          item { math_number 5 }
          item { math_number 6 }
          item { math_number 7 }
          item { math_number 8 }
        end
      end

      string_output do
        lists_get_first do
          variables_get('list')
        end
      end
    end
  end

  it 'gets the last item from a list' do
    assert_outputs "8" do
      variables_set('list') do
        lists_create_with do
          item { math_number 5 }
          item { math_number 6 }
          item { math_number 7 }
          item { math_number 8 }
        end
      end

      string_output do
        lists_get_last do
          variables_get('list')
        end
      end
    end
  end

  it 'gets a random item from a list' do
    assert_outputs "3" do
      variables_set('list') do
        lists_create_with do
          item { math_number 3 }
          item { math_number 3 }
          item { math_number 3 }
          item { math_number 3 }
        end
      end

      string_output do
        lists_get_random do
          variables_get('list')
        end
      end
    end
  end

  it 'gets a start-indexed item from a list' do
    assert_outputs "6" do
      variables_set('list') do
        lists_create_with do
          item { math_number 5 }
          item { math_number 6 }
          item { math_number 7 }
          item { math_number 8 }
        end
      end

      string_output do
        lists_get_index do
          at 2
          list { variables_get('list') }
        end
      end
    end
  end

  it 'gets a start-indexed item from a list' do
    assert_outputs "7" do
      variables_set('list') do
        lists_create_with do
          item { math_number 5 }
          item { math_number 6 }
          item { math_number 7 }
          item { math_number 8 }
        end
      end

      string_output do
        lists_get_index(where: 'FROM_END') do
          at 2
          list { variables_get('list') }
        end
      end
    end
  end

  it 'removes an item from a list' do
    assert_outputs "[5, 7, 8]" do
      variables_set('list') do
        lists_create_with do
          item { math_number 5 }
          item { math_number 6 }
          item { math_number 7 }
          item { math_number 8 }
        end
      end

      lists_get_index(mode: 'REMOVE') do
        at 2
        list { variables_get('list') }
      end

      string_output do
        variables_get('list')
      end
    end
  end

  it 'removes and gets an item from a list' do
    assert_outputs "6\n[5, 7, 8]" do
      variables_set('list') do
        lists_create_with do
          item { math_number 5 }
          item { math_number 6 }
          item { math_number 7 }
          item { math_number 8 }
        end
      end

      string_output do
        lists_get_index(mode: 'GET_REMOVE') do
          at 2
          list { variables_get('list') }
        end
      end

      string_output "\n"

      string_output do
        variables_get('list')
      end
    end
  end
end