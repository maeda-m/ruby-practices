# frozen_string_literal: true

module Bowling
  class Shot
    STRIKE_MARK = 'X'
    MAX_HIT_COUNT = 10

    def initialize(value)
      @value = value
      @used = false
    end

    def strike?
      @value == STRIKE_MARK
    end

    def spare?(other)
      return false if strike?

      self + other == MAX_HIT_COUNT
    end

    def +(other)
      to_i + other.to_i
    end

    def to_i
      return MAX_HIT_COUNT if strike?

      @value.to_i
    end

    def used?
      @used
    end

    def used!
      @used = true
    end
  end
end
