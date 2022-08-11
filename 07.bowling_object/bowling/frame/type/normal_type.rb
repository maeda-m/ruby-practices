# frozen_string_literal: true

require_relative 'abstract_type'
require_relative 'strike_type'
require_relative 'spare_type'

module Bowling
  module Frame
    class NormalType < AbstractType
      def self.comply_with?(first_value, second_value)
        return false if StrikeType.comply_with?(first_value, second_value)
        return false if SpareType.comply_with?(first_value, second_value)

        true
      end

      def bonus_point
        0
      end
    end
  end
end
