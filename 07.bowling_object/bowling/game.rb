# frozen_string_literal: true

require_relative 'frame'

module Bowling
  class Game
    MAX_FRAME_SIZE = 10

    def initialize(records)
      @frames = []
      @values = records.map { |str| RecordValue.new(str) }

      @values.each.with_index do |current_value, current_value_index|
        next if current_value.used?

        shots = find_shots(current_value, current_value_index)
        bonus_point_shots = find_bonus_point_shots(current_value, current_value_index)

        @frames << Frame.new(shots, bonus_point_shots)

        shots.each(&:used!)
      end
    end

    def score
      @frames.sum(&:score)
    end

    private

    def find_shots(current_value, current_value_index)
      slice_shot_size = max_shot_size(current_value)
      @values.slice(current_value_index, slice_shot_size).compact
    end

    def max_shot_size(current_value)
      return 3 if final_frame?

      current_value.strike? ? 1 : 2
    end

    def find_bonus_point_shots(current_value, current_value_index)
      return [] if final_frame?

      next_value_index = current_value_index + 1
      next_value = @values[current_value_index + 1]

      if current_value.strike?
        @values.slice(next_value_index, 2).compact
      elsif current_value.spare?(next_value)
        @values.slice(next_value_index + 1, 1).compact
      else
        []
      end
    end

    def final_frame?
      @frames.size + 1 == MAX_FRAME_SIZE
    end
  end
end
