#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/list'

option = List::Option.new(ARGV)
List::Command.run(option)
