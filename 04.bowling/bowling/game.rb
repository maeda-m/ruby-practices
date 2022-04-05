# frozen_string_literal: true

require_relative 'frame'

module Bowling
  class Game
    MAX_FRAME_SIZE = 10
    MARK_STRIKE = 'X'

    attr_reader :frames

    class << self
      def parse(records)
        game = new

        frame = game.frames.first
        records.split(',').each do |record|
          if record == MARK_STRIKE
            frame.add_strike_shot
          else
            frame.add_shot(record.to_i)
          end

          frame = frame.next_frame if frame.fixed?
        end

        game
      end
    end

    def initialize
      @frames = []
      MAX_FRAME_SIZE.times { add_frame }
    end

    def add_frame
      prev_frame = frames.last
      frames << Frame.new(prev_frame)
    end

    def score
      frames.sum(&:score)
    end
  end
end
