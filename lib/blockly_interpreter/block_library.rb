module BlocklyInterpreter::BlockLibrary
  attr_accessor :block_classes

  def block_classes
    @block_classes ||= []
  end

  def register!(parser_class = BlocklyInterpreter::Parser, block_context_class = BlocklyInterpreter::DSL::BlockContext)
    block_classes.each do |block_class|
      parser_class.register_block_class block_class
      block_context_class.register_block_class block_class
    end
  end
end