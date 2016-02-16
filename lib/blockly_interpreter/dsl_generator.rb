module BlocklyInterpreter::DSLGenerator
  def deep_flatten(obj)
    if obj.respond_to?(:flatten)
      obj.flatten.map { |item| deep_flatten(item) }
    else
      obj
    end
  end

  def strip_trailing_whitespace(code)
    code.gsub(/[ \t]+$/, '')
  end

  def indent(code, level = 2)
    lines = case code
    when String then code.split("\n")
    when BlocklyInterpreter::Block then start_block_to_dsl(code).split("\n")
    when Array then deep_flatten(code).compact.flat_map { |code| code.split("\n") }
    else code
    end

    lines.map { |line| (" " * level) + line }.join("\n")
  end

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

  def method_call_with_possible_block(method_name, args, block_contents, *block_arg_names)
    method_call_with_block_or_nothing(method_name, args, block_contents, *block_arg_names) || method_call(method_name, args)
  end

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

  def keyword_args_without_defaults(keyword_args, default_args)
    keyword_args.reject { |key, value| default_args[key] == value }
  end

  def formatted_keyword_args(keyword_args)
    keyword_args.map { |key, value| "#{key}: #{value.inspect}" }.join(", ")
  end

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

  def timestamp_to_dsl(time)
    return "nil" unless time

    args = [time.year, time.month, time.day, time.hour, time.min, time.sec, time.usec].map(&:inspect).join(", ")
    "Time.utc(#{args})"
  end
end