# frozen_string_literal: true

module Bowling
  class Shot
    attr_reader :pin, :exclude

    def initialize(pin, exclude)
      @pin = pin
      @exclude = exclude
    end

    def exclude?
      exclude
    end
  end
end
