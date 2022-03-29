# frozen_string_literal: true

module Bowling
  class Shot
    attr_accessor :pins, :exclude

    def exclude?
      !!exclude
    end
  end
end
