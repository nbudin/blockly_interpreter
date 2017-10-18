$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'blockly_interpreter'
require 'blockly_interpreter/blockly_interpreter_test_helper'

require 'minitest/spec'
require 'minitest/reporters'
require 'minitest/autorun'

Minitest::Reporters.use!

require 'timecop'
require 'pry'