# frozen_string_literal: true

module Bowling
  module Frame
    class AbstractType
      attr_reader :next_frame, :shots

      def self.inherited(subclass)
        super
        Bowling::FrameTypeRegistry.instance.register_type(subclass)
      end

      def self.comply_with?(first_value, second_value)
        raise NotImplementedError
      end

      def initialize(shots, next_frame = nil)
        @shots = shots
        @next_frame = next_frame
      end

      def score
        shots.sum + bonus_point
      end

      private

      def bonus_point
        raise NotImplementedError
      end

      def right_after_shots(size)
        return [] unless next_frame

        next_frame_shots = next_frame.shots
        after_next_frame_shots = next_frame.next_frame&.shots || []

        (next_frame_shots + after_next_frame_shots).compact.slice(0, size)
      end
    end
  end
end
