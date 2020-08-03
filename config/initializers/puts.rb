# frozen_string_literal: true

def ppp(*args, pad: 0, tpad: nil, bpad: nil, output: :ap, indent: 0)
  tpad ||= pad
  bpad ||= pad
  output = '$stdout.puts' if output == :puts

  $stdout.puts("\n" * tpad) unless tpad.zero?
  args.each { |arg| eval("#{output} arg") }
  res = yield.indent(indent).tap { |res| eval("#{output} res") } if block_given?
  $stdout.puts("\n" * bpad) unless bpad.zero?
  res
end

def indent(n = 0)
  yield.to_s.indent(n) if block_given?
end
