# frozen_string_literal: true

module Bowling
  module Frame
    class RecordValue
      STRIKE_MARK = 'X'
      STRIKE_HIT_COUNT = 10

      def initialize(str)
        @str = str
      end

      def strike?
        @str == STRIKE_MARK
      end

      def +(other)
        to_i + other.to_i
      end

      def to_i
        return STRIKE_HIT_COUNT if strike?

        @str.to_i
      end
    end
  end
end
