# blockly_interpreter

An interpreter for [Blockly](https://developers.google.com/blockly/) programs, written in Ruby.  blockly_interpreter provides:

* Implementations of most (but not all) of the blocks that Blockly ships with
* The capability to easily implement your own block types
* Several optional extension blocks to allow accessing Ruby and Rails features
* A DSL for writing Blockly programs in Ruby
* Automatic import and export capabilities to translate between that DSL and Blockly XML code

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blockly_interpreter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blockly_interpreter

## Basic Usage

To begin with, you'll probably want a global instance of `BlocklyInterpreter::ProgramCache`.  This class is thread-safe, so you can use a global instance in multithreaded apps.

```ruby
my_program_cache = BlocklyInterpreter::ProgramCache.new
```

Then, load and parse the program, which will return a `BlocklyInterpreter::Program` object.

```ruby
program = my_program_cache.load_program("<xml>...</xml>")
```

Finally, spin up a `BlocklyInterpreter::Interpreter` and run your program:

```ruby
interpreter = BlocklyInterpreter::Interpreter.new
interpreter.execute(program)
```

## Custom Interpreters and Execution Contexts

In many situations, you might need to create a custom interpreter subclass.  For example:

* You might want the Blockly program to produce some particular type of output
* You might want to provide additional context for the program to use when it runs
* You might want to create custom blocks for certain types of Blockly programs to use

To do this, you'll likely need to create subclasses of two things: `BlocklyInterpreter::ExecutionContext` and `BlocklyInterpreter::Interpreter`.  The `BlocklyInterpreter::ExecutionContext` object is passed into all Block classes in their `execute_statement` and `value` methods, so it can be used to expose external objects to custom blocks, or to allow custom blocks to set output values from the program.  The `BlocklyInterpreter::Interpreter` object is the external interface that allows programs to be run, so it will need to be configured to use your custom `ExecutionContext` class, to set it up with the right input values, and to expose any output values it might produce.

For an example of how this might work, see `TestInterpreter` and `TestInterpreter::ExecutionContext` in `test/test_helper.rb`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/patientslikeme/blockly_interpreter.

## License

blockly_interpreter Copyright &copy; PatientsLikeMe, Inc. and is distributed under the terms and conditions of the MIT License.  See the COPYING file for details.