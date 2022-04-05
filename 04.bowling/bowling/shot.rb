# frozen_string_literal: true

module Bowling
  class Shot
    attr_reader :hit_count, :exclude

    def initialize(hit_count, exclude)
      @hit_count = hit_count
      @exclude = exclude
    end

    def exclude?
      exclude
    end
  end
end
