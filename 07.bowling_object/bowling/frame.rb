# frozen_string_literal: true

module Bowling
  class Frame
    def initialize(shots, bonus_point_shots)
      @shots = shots
      @bonus_point_shots = bonus_point_shots
    end

    def score
      (@shots + @bonus_point_shots).map(&:to_i).sum
    end
  end
end
