class BlocklyInterpreter::ConsoleInterpreter < BlocklyInterpreter::Interpreter
  class ConsolePrintBlock < BlocklyInterpreter::Interpreter::Block
    def execute_statement(execution_context)
      puts values['VALUE'].value(execution_context)
    end
  end

  def block_class_for_element(element)
    case element['type']
    when 'console_print' then ConsolePrintBlock
    else
      super(element)
    end
  end
end