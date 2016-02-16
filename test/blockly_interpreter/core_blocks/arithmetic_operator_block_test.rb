require 'test_helper'

describe BlocklyInterpreter::CoreBlocks::ArithmeticOperatorBlock do
  include InterpreterTestingMethods

  it 'adds numbers' do
    assert_outputs "8" do
      string_output { math_arithmetic :ADD, 1, 7 }
    end
  end

  it 'subtracts numbers' do
    assert_outputs "2" do
      string_output { math_arithmetic :MINUS, 10, 8 }
    end
  end

  it 'multiplies numbers' do
    assert_outputs "6" do
      string_output { math_arithmetic :MULTIPLY, 2, 3 }
    end
  end

  it 'divides numbers' do
    assert_outputs "3" do
      string_output { math_arithmetic :DIVIDE, 6, 2 }
    end
  end

  it 'raises numbers to exponents' do
    assert_outputs "9" do
      string_output { math_arithmetic :POWER, 3, 2 }
    end
  end
end