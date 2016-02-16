require 'test_helper'

describe BlocklyInterpreter::ExtensionBlocks::DateTodayBlock do
  include InterpreterTestingMethods

  it "returns today's date" do
    Timecop.freeze do
      assert_outputs(Date.today.to_s) do
        string_output { date_today }
      end
    end
  end
end