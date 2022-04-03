# frozen_string_literal: true

module List
  class Core
    attr_reader :options

    def initialize(path, options)
      @options = options
    end

    def entries
    end
  end
end
