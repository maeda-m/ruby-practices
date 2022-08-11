# frozen_string_literal: true

require_relative 'abstract_type'
require_relative 'strike_type'

module Bowling
  module Frame
    class SpareType < AbstractType
      MAX_HIT_COUNT = 10

      def self.comply_with?(first_value, second_value)
        return false if StrikeType.comply_with?(first_value, second_value)

        (first_value.to_i + second_value.to_i) == MAX_HIT_COUNT
      end

      def bonus_point
        right_after_shots(1).sum
      end
    end
  end
end
