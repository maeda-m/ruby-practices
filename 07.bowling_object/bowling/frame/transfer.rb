# frozen_string_literal: true

module Bowling
  module Frame
    class Transfer
      MAX_FRAME_SIZE = 10

      def initialize(frame_type_class, position)
        @frame_type_class = frame_type_class
        @position = position
        @shots = []
      end

      def to_frame(next_frame)
        shots = @shots.map(&:to_i)

        @frame_type_class.new(shots, next_frame)
      end

      def add_shot(value)
        @shots << value
      end

      def next_frame?
        if final_frame?
          max_shot_size = 3
        else
          return true if @shots.first.strike?

          max_shot_size = 2
        end

        @shots.size == max_shot_size
      end

      private

      def final_frame?
        @position == MAX_FRAME_SIZE
      end
    end
  end
end
