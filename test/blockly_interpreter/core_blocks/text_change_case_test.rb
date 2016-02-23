require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::TextChangeCaseBlock do
  include InterpreterTestingMethods

  it 'upper-cases a string' do
    assert_outputs('SOME STRING') do
      string_output do
        text_change_case("UPPERCASE") { text 'some string' }
      end
    end
  end

  it 'lower-cases a string' do
    assert_outputs('some string') do
      string_output do
        text_change_case("LOWERCASE") { text 'SoMe STRing' }
      end
    end
  end

  it 'title-cases a string' do
    assert_outputs("X Men: The Last Stand") do
      string_output do
        text_change_case("TITLECASE") { text 'x men: the last stand' }
      end
    end
  end
end
