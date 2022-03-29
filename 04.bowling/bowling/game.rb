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

        current_frame = game.frames.first
        records.split(',').each do |record|
          if record == Game::MARKS[:strike]
            current_frame.add_strike_shot
          else
            current_frame.add_shot(record.to_i)
          end

          current_frame = current_frame.next_frame if current_frame.fixed?
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
      prev_frame_position = 0
      prev_frame_position = prev_frame.position if prev_frame

      frame_position = prev_frame_position + 1
      frame ||= Frame.new(frame_position)
      frame.prev_frame = prev_frame

      self.frames << frame

      frame
    end

    def score
      self.frames.sum(&:score)
    end
  end
end

require_relative 'frame'
