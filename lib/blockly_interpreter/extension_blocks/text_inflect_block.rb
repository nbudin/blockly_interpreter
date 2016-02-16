class BlocklyInterpreter::ExtensionBlocks::TextInflectBlock < BlocklyInterpreter::Block
  INFLECTIONS = %w(
    humanize
    pluralize
    singularize
    titleize
    camelize
    classify
    dasherize
    deconstantize
    demodulize
    parameterize
    tableize
    underscore
  )

  self.block_type = :text_inflect

  def value(execution_context)
    text = values['TEXT'].value(execution_context)

    case fields['OP']
    when *INFLECTIONS then text.public_send(fields['OP'])
    else text
    end
  end
end