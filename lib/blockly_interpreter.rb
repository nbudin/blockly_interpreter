require "blockly_interpreter/version"
require "active_support/dependencies/autoload"
require "active_support/core_ext"

if defined?(::Rails::Engine)
  # Rails autoloading will take care of the requires for us, and explicitly doing it will
  # break it.
  require 'blockly_interpreter/engine'
else
  module BlocklyInterpreter
    extend ActiveSupport::Autoload

    autoload :Block
    autoload :BlockLibrary
    autoload :CoreBlocks
    autoload :DSL
    autoload :DSLGenerator
    autoload :ExecutionContext
    autoload :GenericBlockDSLGenerator
    autoload :Interpreter
    autoload :Parser
    autoload :ProgramCache
    autoload :Program
  end
end
