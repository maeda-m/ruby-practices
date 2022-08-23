# frozen_string_literal: true

require_relative 'abstract_type'

module Bowling
  module Frame
    class SpareType < AbstractType
      MAX_HIT_COUNT = 10

      def self.comply_with?(first_value, second_value)
        (first_value.to_i + second_value.to_i) == MAX_HIT_COUNT
      end

      private

      def bonus_point
        bonus_point_shots(1).sum
      end
    end
  end
end
