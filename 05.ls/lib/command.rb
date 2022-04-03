# frozen_string_literal: true

require_relative 'core'
require_relative 'rendering'

module List
  module Command
    def self.run(option)
      core = List::Core.new(option.path, option.core_options)
      List::Rendering.new(option.render_options).render(core.entries)
    end
  end
end
