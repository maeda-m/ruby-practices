# frozen_string_literal: true

require_relative 'abstract_type'

module Bowling
  module Frame
    class NormalType < AbstractType
      private

      def bonus_point
        0
      end
    end
  end
end
