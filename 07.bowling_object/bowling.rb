#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'bowling/game'

module Bowling
  def self.play(record)
    records = record.split(',')
    game = Game.new(records)

    game.score
  end
end

if __FILE__ == $PROGRAM_NAME
  record = ARGV[0]

  puts Bowling.play(record)
end
