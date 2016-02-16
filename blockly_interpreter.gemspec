# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blockly_interpreter/version'

Gem::Specification.new do |spec|
  spec.name          = "blockly_interpreter"
  spec.version       = BlocklyInterpreter::VERSION
  spec.authors       = ["Nat Budin"]
  spec.email         = ["nbudin@patientslikeme.com"]

  spec.summary       = %q{An interpreter for Blockly programs}
  spec.description   = %q{Blockly is a library from Google for building visual programming editors.  This gem is an interpreter for Blockly programs in Ruby.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "terminal-notifier-guard"
end
