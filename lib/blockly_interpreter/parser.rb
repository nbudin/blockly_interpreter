class BlocklyInterpreter::Parser
  class UnknownBlockTypeError < StandardError
  end

  def self.registered_block_types
    @registered_block_types ||= {}
  end

  def self.register_block_class(block_class)
    raise "Block class #{block_class} has no type specified" unless block_class.block_type
    registered_block_types[block_class.block_type.to_sym] = block_class
  end

  def self.registered_block_class_for_type(block_type)
    block_class = registered_block_types[block_type.to_sym]

    if block_class
      block_class
    elsif superclass.respond_to?(:registered_block_class_for_type)
      superclass.registered_block_class_for_type(block_type)
    end
  end

  def parse(xml)
    dom = Nokogiri::XML.parse(xml)

    if dom.root
      procs, nonprocs = dom.root.css('> block').partition do |element|
        ['procedures_defreturn', 'procedures_defnoreturn'].include? element['type']
      end

      procedures = procs.map { |element| block_from_dom(element) }.index_by(&:procedure_name)
      first_block = block_from_dom(nonprocs.first)
    else
      first_block = nil
      procedures = {}
    end

    BlocklyInterpreter::Program.new(first_block, procedures)
  end

  def block_from_dom(element)
    return unless element
    block_class_for_element(element).new(
      element['type'],
      fields_from_element(element),
      values_from_element(element),
      statements_from_element(element),
      next_block_from_element(element),
      mutation_from_element(element),
      comment_from_element(element),
      comment_pinned_from_element(element),
      element.name == 'shadow',
      element['x'],
      element['y']
    )
  end

  private

  def block_class_for_element(element)
    block_type = element['type']
    block_class = self.class.registered_block_class_for_type(block_type)

    if block_class
      block_class
    else
      raise UnknownBlockTypeError.new("#{element['type']} is not a registered block type")
    end
  end

  def values_from_element(element)
    children_by_name(element, '> value') do |child|
      block_from_dom(child.css('> block').first || child.css('> shadow').first)
    end
  end

  def statements_from_element(element)
    children_by_name(element, '> statement') do |child|
      block_from_dom(child.css('> block').first || child.css('> shadow').first)
    end
  end

  def fields_from_element(element)
    children_by_name(element, '> field') do |child|
      child.text
    end
  end

  def next_block_from_element(element)
    next_block_element = element.css('> next > block').first || element.css('> next > shadow').first
    block_from_dom(next_block_element) if next_block_element
  end

  def mutation_from_element(element)
    element.css('> mutation').first
  end

  def comment_from_element(element)
    element.css('> comment').first.try!(:text)
  end

  def comment_pinned_from_element(element)
    element.css('> comment').first.try { |comment| comment['pinned'] == 'true' }
  end

  def children_by_name(xml, selector, &block)
    xml.css(selector).map do |child|
      processed_child = block_given? ? yield(child) : child
      [child['name'], processed_child]
    end.to_h
  end
end

BlocklyInterpreter::CoreBlocks.register!