module BlocklyInterpreter
  class Engine < ::Rails::Engine
    engine_name 'blockly_interpreter'
    isolate_namespace BlocklyInterpreter

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
