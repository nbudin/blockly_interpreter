class BlocklyInterpreter::ExtensionBlocks::DebugMessageBlock < BlocklyInterpreter::Block
  self.block_type = 'debug_message'

  def execute_statement(execution_context)
    message = values['MESSAGE'].value(execution_context)
    message = message.inspect unless message.is_a?(String)
    execution_context.add_debug_message message
  end

  module DSLMethods
    def debug_message(msg = nil, &proc)
      proc ||= Proc.new { text msg }
      block 'debug_message' do
        value 'MESSAGE', &proc
      end
    end
  end
end