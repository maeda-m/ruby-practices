# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

module Bowling
  class Game
    MAX_FRAME_SIZE = 10

    def initialize(records)
      @frames = []
      @shots = records.map { |value| Shot.new(value) }

      @shots.each.with_index do |shot, i|
        next if shot.used?

        shots = find_frame_shots(shot, i)
        bonus_point_shots = find_bonus_point_shots(shot, i)

        @frames << Frame.new(shots, bonus_point_shots)

        shots.each(&:used!)
      end
    end

    def score
      @frames.sum(&:score)
    end

    private

    def find_frame_shots(first_shot, first_shot_index)
      slice_shot_size = max_frame_shot_size(first_shot)
      @shots.slice(first_shot_index, slice_shot_size)
    end

    def max_frame_shot_size(first_shot)
      return 3 if final_frame?

      first_shot.strike? ? 1 : 2
    end

    def find_bonus_point_shots(first_shot, first_shot_index)
      return [] if final_frame?

      second_shot_index = first_shot_index + 1
      second_shot = @shots[second_shot_index]

      if first_shot.strike?
        @shots.slice(second_shot_index, 2)
      elsif first_shot.spare?(second_shot)
        @shots.slice(second_shot_index + 1, 1)
      else
        []
      end
    end

    def final_frame?
      @frames.size + 1 == MAX_FRAME_SIZE
    end
  end
end
