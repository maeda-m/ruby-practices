# frozen_string_literal: true

require_relative 'abstract_type'

module Bowling
  module Frame
    class StrikeType < AbstractType
      def self.comply_with?(first_value, _)
        first_value.strike?
      end

      def bonus_point
        right_after_shots(2).sum
      end
    end
  end
end
