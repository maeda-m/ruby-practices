# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

module Bowling
  class Game
    MAX_FRAME_SIZE = 10

    def initialize(records)
      @frames = (1..MAX_FRAME_SIZE).to_a.map { |i| Frame.new(i) }

      @shots = records.map { |record| Shot.new(record) }
      @shots.each do |shot|
        current_frame = @frames.find { |frame| !frame.finalized? }
        current_frame.shots << shot
      end
    end

    def score
      @frames.sum { |frame| frame.hit_count + bonus_point_shots(frame).sum }
    end

    private

    def bonus_point_shots(frame)
      return [] if frame.final_frame?

      next_shot_index = @shots.find_index(frame.shots.last) + 1
      shot_size = frame.bonus_point_shot_size

      @shots.slice(next_shot_index, shot_size)
    end
  end
end
