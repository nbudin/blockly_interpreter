require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::RepeatTimesBlock do
  include InterpreterTestingMethods

  it 'loops n times' do
    assert_outputs "HaHaHa" do
      repeat_times(3) { string_output "Ha" }
    end
  end
end