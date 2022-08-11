# frozen_string_literal: true

require_relative 'frame'

module Bowling
  class Game
    def initialize(records)
      frames = Frame.build(records)
      @frames = frames
    end

    def score
      @frames.sum(&:score)
    end
  end
end
