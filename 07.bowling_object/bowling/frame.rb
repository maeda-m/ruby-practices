# frozen_string_literal: true

module Bowling
  class Frame
    MAX_HIT_COUNT = 10
    FINAL_FRAME_POSITION = 10

    attr_reader :shots

    def initialize(position)
      @shots = []
      @position = position
    end

    def hit_count
      @shots.sum
    end

    def bonus_point_shot_size
      return 2 if strike?
      return 1 if spare?

      0
    end

    def strike?
      @shots.first == MAX_HIT_COUNT
    end

    def spare?
      return false if strike?

      @shots.sum == MAX_HIT_COUNT
    end

    def finalized?
      if final_frame?
        max_shot_size = 3
      else
        return true if strike?

        max_shot_size = 2
      end

      @shots.size == max_shot_size
    end

    def final_frame?
      @position == FINAL_FRAME_POSITION
    end
  end
end
