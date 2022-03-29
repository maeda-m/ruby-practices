# frozen_string_literal: true

module Bowling
  class Frame
    MAX_SHOT_PINS = 10

    attr_accessor :position, :shots, :next_frame
    attr_reader :prev_frame

    class << self
      def sibling_shots(expected_size, frame, shots = [])
        return shots unless frame

        shots += frame.shots.reject(&:exclude?).slice(0, expected_size)
        shots = sibling_shots(expected_size - shots.size, frame.next_frame, shots) if shots.size < expected_size

        shots
      end
    end

    def initialize(position, shots = [])
      @position = position
      @shots = shots
    end

    def final_frame?
      position == Game::MAX_FRAME_SIZE
    end

    def fixed?
      max_shot_size <= shots.size
    end

    def max_shot_size
      final_frame? ? 3 : 2
    end

    def prev_frame=(frame)
      return unless frame

      @prev_frame = frame
      frame.next_frame = self
    end

    def add_shot(pins)
      self.shots ||= []

      shot = Shot.new.tap { |b| b.pins = pins }
      self.shots << shot

      shot
    end

    def add_strike_shot
      shot = add_shot(Frame::MAX_SHOT_PINS)
      add_shot(0).exclude = true unless final_frame?

      shot
    end

    def spare?
      self.shots.sum(&:pins) == Frame::MAX_SHOT_PINS
    end

    def strike?
      self.shots.first.pins == Frame::MAX_SHOT_PINS
    end

    def bonus_points
      points = 0
      return points unless next_frame

      return self.class.sibling_shots(2, next_frame).sum(&:pins) if strike?
      return self.class.sibling_shots(1, next_frame).sum(&:pins) if spare?

      points
    end

    def score
      bonus_points + shots.sum(&:pins)
    end
  end
end

require_relative 'shot'
