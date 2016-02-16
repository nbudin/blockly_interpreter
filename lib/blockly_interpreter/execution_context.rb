class BlocklyInterpreter::ExecutionContext
  attr_reader :interpreter, :early_return_value, :terminated, :debug_messages

  def initialize(interpreter)
    @interpreter = interpreter
    @variables = {}
    @early_return_value = nil
    @terminated = false
    @debug_messages = []
  end

  def get_variable(name)
    @variables[name.to_s.upcase]
  end

  def set_variable(name, value)
    @variables[name.to_s.upcase] = value
  end

  def set_variables(hash)
    hash.each do |name, value|
      set_variable(name, value)
    end
  end

  def merge_state_from(context)
  end

  def execute(block)
    current_block = block

    while current_block && !terminated
      current_block.execute_statement(self)
      current_block = current_block.next_block
    end
  end

  def early_return!(value = nil)
    @terminated = true
    @early_return_value = value
  end

  def execute_procedure(name, parameters)
    procedure_block = interpreter.program.procedures[name]

    interpreter.build_execution_context.tap do |proc_context|
      proc_context.set_variables(@variables.merge(procedure_block.arg_hash(parameters)))
      proc_context.execute(procedure_block)
      merge_state_from(proc_context)
    end
  end

  def value_for_procedure(name, parameters)
    procedure_block = interpreter.program.procedures[name]

    proc_context = interpreter.build_execution_context
    proc_context.set_variables(@variables.merge(procedure_block.arg_hash(parameters)))

    procedure_block.value(proc_context).tap do |value|
      merge_state_from(proc_context)
    end
  end

  def add_debug_message(message)
    if message.present?
      Logger.new(STDERR).debug message 
      debug_messages << message
    end 
  end
end
