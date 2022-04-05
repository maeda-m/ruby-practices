# frozen_string_literal: true

module Bowling
  class Game
    MAX_FRAME_SIZE = 10

    MARKS = {
      strike: 'X'
    }.freeze

    attr_accessor :frames

    class << self
      def parse(records)
        game = new
        Game::MAX_FRAME_SIZE.times { |_i| game.add_frame }

        frame = game.frames.first
        records.split(',').each do |record|
          if record == Game::MARKS[:strike]
            frame.add_strike_shot
          else
            frame.add_shot(record.to_i)
          end

          frame = frame.next_frame if frame.fixed?
        end

        game
      end
    end

    def initialize(frames = [])
      frames.each { |frame| add_frame(frame) }
    end

    def add_frame(frame = nil)
      self.frames ||= []

      prev_frame = self.frames.last
      frame ||= Frame.new(prev_frame)

      self.frames << frame

      frame
    end

    def score
      frames.sum(&:score)
    end
  end
end

require_relative 'frame'
