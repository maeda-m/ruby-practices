# frozen_string_literal: true

module Bowling
  module Frame
    class Transfer
      def initialize(frame_type_class)
        @frame_type_class = frame_type_class
        @shots = []
      end

      def add_shot(value)
        @shots << value
      end

      def finalized?(is_final_frame)
        if is_final_frame
          max_shot_size = 3
        else
          return true if @shots.first.strike?

          max_shot_size = 2
        end
        max_shot_size == @shots.size
      end

      def convert(next_frame)
        shots = @shots.map(&:to_i)

        @frame_type_class.new(shots, next_frame)
      end
    end
  end
end
