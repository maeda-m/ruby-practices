# frozen_string_literal: true

require_relative 'shot'

module Bowling
  class Frame
    MAX_SHOT_PIN = 10

    attr_accessor :next_frame
    attr_reader :position, :shots, :prev_frame

    class << self
      def sibling_shots(expected_size, frame)
        return [] unless frame

        shots = frame.shots.reject(&:exclude?).slice(0, expected_size)

        if shots.size < expected_size
          expected_size -= shots.size
          shots += sibling_shots(expected_size, frame.next_frame)
        end

        shots
      end
    end

    def initialize(prev_frame = nil)
      @prev_frame = prev_frame
      @position = prev_frame&.position.to_i + 1
      @shots = []

      after_initialize
    end

    def add_shot(pin, exclude: false)
      shots << Shot.new(pin, exclude)
    end

    def add_strike_shot
      add_shot(MAX_SHOT_PIN)
      add_shot(0, exclude: true) unless final_frame?
    end

    def score
      bonus_points + shots.sum(&:pin)
    end

    def fixed?
      max_shot_size == shots.size
    end

    private

    def after_initialize
      prev_frame&.next_frame = self
    end

    def bonus_points
      points = 0
      return points unless next_frame

      return Frame.sibling_shots(2, next_frame).sum(&:pin) if strike?
      return Frame.sibling_shots(1, next_frame).sum(&:pin) if spare?

      points
    end

    def strike?
      shots.first.pin == MAX_SHOT_PIN
    end

    def spare?
      return false if strike?

      shots.sum(&:pin) == MAX_SHOT_PIN
    end

    def max_shot_size
      final_frame? ? 3 : 2
    end

    def final_frame?
      position == Game::MAX_FRAME_SIZE
    end
  end
end
