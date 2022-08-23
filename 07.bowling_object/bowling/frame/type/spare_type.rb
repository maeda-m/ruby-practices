# frozen_string_literal: true

require_relative 'abstract_type'

module Bowling
  module Frame
    class SpareType < AbstractType
      private

      def bonus_point
        bonus_point_shots(1).sum
      end
    end
  end
end
