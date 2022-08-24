# frozen_string_literal: true

module Bowling
  class RecordValue
    STRIKE_MARK = 'X'
    MAX_HIT_COUNT = 10

    def initialize(str)
      @str = str
      @used = false
    end

    def strike?
      @str == STRIKE_MARK
    end

    def spare?(other)
      return false if strike?
      return false if other.strike?

      self + other == MAX_HIT_COUNT
    end

    def +(other)
      to_i + other.to_i
    end

    def to_i
      return MAX_HIT_COUNT if strike?

      @str.to_i
    end

    def used?
      @used
    end

    def used!
      @used = true
    end
  end
end
