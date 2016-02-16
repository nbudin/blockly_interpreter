require 'digest/sha1'
require 'monitor'

class BlocklyInterpreter::ProgramCache
  include MonitorMixin
  attr_reader :parser

  def initialize(parser)
    @parser = parser
    @cache = {}
    super()
  end

  def load_program(xml)
    synchronize do
      @cache[Digest::SHA1.hexdigest(xml || '')] ||= @parser.parse(xml)
    end
  end
end