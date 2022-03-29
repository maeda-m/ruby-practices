#!/usr/bin/env ruby
# frozen_string_literal: true

module Bowling
  def self.play(record)
    game = Bowling::Game.parse(record)

    game.score
  end
end

require_relative 'bowling/game'

if __FILE__ == $PROGRAM_NAME
  record = ARGV[0]

  puts Bowling.play(record)
end
