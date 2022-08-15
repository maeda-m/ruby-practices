# frozen_string_literal: true

require_relative 'abstract_type'

module Bowling
  module Frame
    class StrikeType < AbstractType
      def self.comply_with?(first_value, _)
        first_value.strike?
      end

      private

      def bonus_point
        bonus_point_shots(2).sum
      end
    end
  end
end
