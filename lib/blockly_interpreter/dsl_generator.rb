module BlocklyInterpreter::DSLGenerator
  # Calls #flatten on an enumerable object recursively.  Any flattenable things inside obj will also be flattened.
  def deep_flatten(obj)
    if obj.respond_to?(:flatten)
      obj.flatten.map { |item| deep_flatten(item) }
    else
      obj
    end
  end

  # Given a piece of code as a string, removes any trailing whitespace from each line.
  def strip_trailing_whitespace(code)
    code.gsub(/[ \t]+$/, '')
  end

  # Given a piece of code, indents it by `level` spaces.
  #
  # indent can accept code as a string (obviously), but can also accept a BlocklyInterpreter::Block, which will
  # automatically be converted to a DSL string and then indented.  It can also accept Arrays consisting of strings,
  # BlocklyInterpreter::Blocks, other arrays, and nil, which will be concatenated and indented.
  def indent(code, level = 2)
    lines = case code
    when String then code.split("\n")
    when BlocklyInterpreter::Block then start_block_to_dsl(code).split("\n")
    when Array then deep_flatten(code).compact.flat_map { |code| code.split("\n") }
    else code
    end

    lines.map { |line| (" " * level) + line }.join("\n")
  end

  # Generates a Ruby method call given a method name and an arguments string.  If `parens` is true, the arguments
  # will be wrapped in parentheses; otherwise, the parentheses will be omitted.
  def method_call(method_name, args, parens = false)
    code = if parens
      method_name.dup.tap do |ruby|
        ruby << "(#{args})" if args.present?
      end
    else
      [method_name, args].map(&:presence).compact.join(" ")
    end

    strip_trailing_whitespace(code)
  end

  # Generates a Ruby method call with a block.  If `block_contents` is missing, generates the method call with the
  # block omitted.  See `method_call_with_block_or_nothing` for argument descriptions.
  def method_call_with_possible_block(method_name, args, block_contents, *block_arg_names)
    method_call_with_block_or_nothing(method_name, args, block_contents, *block_arg_names) || method_call(method_name, args)
  end

  # Generates a Ruby method call with a block.  If `block_contents` is missing, this method will return nil.
  #
  # Arguments:
  # * `method_name` - the name of the method, as a string
  # * `args` - an arguments string for the method call, or nil if there are no arguments
  # * `block_contents` - an indentable object (i.e. a string, BlocklyInterpreter::Block, or array thereof)
  # * `block_arg_names` - an arguments string for the argument names that will be passed to the block
  #
  # Example:
  #
  #     > puts method_call_with_block_or_nothing("each", nil, "puts i + 3", "i")
  #     each do |i|
  #       puts i + 3
  #     end
  def method_call_with_block_or_nothing(method_name, args, block_contents, *block_arg_names)
    return unless block_contents.present?

    block_args = if block_arg_names.present?
      " |#{block_arg_names.join(", ")}|"
    else
      ""
    end

    unindented_contents = indent(block_contents, 0)
    code = if unindented_contents.size < 40 && !(unindented_contents =~ /\n/)
      "#{method_call(method_name, args, true)} {#{block_args} #{unindented_contents} }"
    else
      <<-DSL
#{method_call(method_name, args)} do#{block_args}
#{indent block_contents}
end
DSL
    end

    strip_trailing_whitespace(code)
  end

  # Given a hash of keyword arguments to a method and a second hash containing that method's default arguments,
  # returns a hash containing all the `keyword_args` omitting the ones that are already the method's default value
  # for that argument.
  #
  # Example:
  #
  #     > keyword_args_without_defaults({ field_type: 'radio', placeholder_text: 'Enter an answer' }, { field_type: 'default', placeholder_text: 'Enter an answer' })
  #     -> { field_type: 'radio' }
  def keyword_args_without_defaults(keyword_args, default_args)
    keyword_args.reject { |key, value| default_args[key] == value }
  end

  # Given a hash of keyword arguments for a method call, returns a string containing those arguments as they should
  # be passed to the method.
  def formatted_keyword_args(keyword_args)
    keyword_args.map { |key, value| "#{key}: #{value.inspect}" }.join(", ")
  end

  # Given a BlocklyInterpreter::Block, returns a DSL string that will generate that block.
  def start_block_to_dsl(block)
    return "" unless block

    block_dsls = block.each_block(false).map do |block|
      dsl_content = block.to_dsl

      if block.has_comment?
        dsl_content = method_call_with_possible_block(
          "with_comment",
          [block.comment, block.comment_pinned].compact.map(&:inspect).join(", "),
          dsl_content
        )
      end

      if block.is_shadow?
        dsl_content = method_call_with_possible_block("shadow", "", dsl_content)
      end

      if block.has_position?
        dsl_content = method_call_with_possible_block("with_position", [block.x, block.y].map(&:inspect).join(", "), dsl_content)
      end

      dsl_content
    end
    block_dsls.join("\n")
  end

  # Given a Time object (or nil), generates a Ruby string representation of that object.
  #
  # Example:
  #
  #     > puts timestamp_to_dsl(Time.now)
  #     Time.utc(2016, 3, 31, 11, 54, 24, 0, 0)
  def timestamp_to_dsl(time)
    return "nil" unless time

    args = [time.year, time.month, time.day, time.hour, time.min, time.sec, time.usec].map(&:inspect).join(", ")
    "Time.utc(#{args})"
  end
end