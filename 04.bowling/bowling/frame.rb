# frozen_string_literal: true

require_relative 'shot'

module Bowling
  class Frame
    MAX_HIT_COUNT = 10

    attr_accessor :next_frame
    attr_reader :position, :shots, :prev_frame

    def initialize(prev_frame = nil)
      @prev_frame = prev_frame
      @position = prev_frame&.position.to_i + 1
      @shots = []

      prev_frame&.next_frame = self
    end

    def add_shot(hit_count, exclude: false)
      shots << Shot.new(hit_count, exclude)
    end

    def add_strike_shot
      add_shot(MAX_HIT_COUNT)
      add_shot(0, exclude: true) unless final_frame?
    end

    def score
      bonus_point + shots.sum(&:hit_count)
    end

    def fixed?
      max_shot_size == shots.size
    end

    private

    def bonus_point
      points = 0
      return points unless next_frame

      return sibling_shots(2, next_frame).sum(&:hit_count) if strike?
      return sibling_shots(1, next_frame).sum(&:hit_count) if spare?

      points
    end

    def sibling_shots(expected_size, frame)
      return [] unless frame

      frame.shots.reject(&:exclude?).slice(0, expected_size).then do |shots|
        if shots.size < expected_size
          expected_size -= shots.size
          shots += sibling_shots(expected_size, frame.next_frame)
        end

        shots
      end
    end

    def strike?
      shots.first.hit_count == MAX_HIT_COUNT
    end

    def spare?
      return false if strike?

      shots.sum(&:hit_count) == MAX_HIT_COUNT
    end

    def max_shot_size
      final_frame? ? 3 : 2
    end

    def final_frame?
      position == Game::MAX_FRAME_SIZE
    end
  end
end
