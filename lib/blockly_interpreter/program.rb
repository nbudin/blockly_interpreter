require 'nokogiri'

class BlocklyInterpreter::Program
  include BlocklyInterpreter::DSLGenerator
  attr_reader :first_block, :procedures

  def initialize(first_block, procedures = {})
    @first_block = first_block
    @procedures = procedures
  end

  def each_block(iterate_subblocks = true)
    return to_enum(:each_block, iterate_subblocks) unless block_given?

    if first_block
      first_block.each_block(iterate_subblocks) do |block|
        yield block
      end
    end

    procedures.values.each do |procedure|
      procedure.each_block(iterate_subblocks) do |block|
        yield block
      end
    end
  end

  def to_dsl
    dsl = ""

    procedure_dsls = procedures.map do |key, start_block|
      start_block_to_dsl(start_block)
    end

    procedures_dsl = method_call_with_block_or_nothing("procedures", "", procedure_dsls.join("\n"))
    [procedures_dsl, start_block_to_dsl(first_block)].compact.join("\n")
  end

  def to_xml_document
    Nokogiri::XML::Document.new.tap do |doc|
      doc.add_child first_block.to_xml_element(doc)
      procedures.each do |_, procedure|
        doc.add_child procedure.to_xml_element(doc)
      end
    end
  end

  def to_xml(options = {})
    to_xml_document.to_xml(options)
  end
end