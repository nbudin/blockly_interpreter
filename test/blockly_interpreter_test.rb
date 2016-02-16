require 'test_helper'

class BlocklyInterpreterTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::BlocklyInterpreter::VERSION
  end
end
