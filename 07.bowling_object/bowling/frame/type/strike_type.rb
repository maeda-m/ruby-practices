# frozen_string_literal: true

require_relative 'abstract_type'

module Bowling
  module Frame
    class StrikeType < AbstractType
      private

      def bonus_point
        bonus_point_shots(2).sum
      end
    end
  end
end
