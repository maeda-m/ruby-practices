#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/list'

if __FILE__ == $PROGRAM_NAME
  option = List::Option.new(ARGV)

  List::Command.run(option)
end
