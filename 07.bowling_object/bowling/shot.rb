# frozen_string_literal: true

module Bowling
  class Shot
    STRIKE_MARK = 'X'
    STRIKE_HIT_COUNT = 10

    def initialize(str)
      @str = str
    end

    # See: https://docs.ruby-lang.org/ja/latest/method/Numeric/i/coerce.html
    def coerce(other)
      [other, to_i]
    end

    def ==(other)
      return to_i == other if other.is_a?(Integer)

      super
    end

    def to_i
      return STRIKE_HIT_COUNT if @str == STRIKE_MARK

      @str.to_i
    end
  end
end
