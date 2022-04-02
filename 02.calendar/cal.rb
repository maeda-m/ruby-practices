#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'calendar'

year = nil
month = nil

optparse = OptionParser.new do |opts|
  opts.banner = 'Usage: cal.rb -y 2022 -m 3'

  opts.separator ''
  opts.separator 'Options:'

  opts.on('-m', '--month MONTH', '') { |m| month = m.to_i }
  opts.on('-y', '--year YEAR', '') { |y| year = y.to_i }

  opts.on_tail('-h', '--help', '') do
    puts opts
    exit 1
  end
end
optparse.parse!

cal = Calendar.new(year, month)
cal.show
