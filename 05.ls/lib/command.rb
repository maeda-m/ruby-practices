# frozen_string_literal: true

require_relative 'core'
require_relative 'rendering'

module List
  module Command
    def self.run(option)
      core = List::Core.new(option.path)
      List::Rendering.new.render(core.entries)
    rescue List::NotFoundOrAccessDeniedError => e
      puts e.message
    end
  end
end
