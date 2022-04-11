# frozen_string_literal: true

require_relative 'core'
require_relative 'column_layout'

module List
  module Command
    def self.run(option)
      core = List::Core.new(option)
      List::ColumnLayout.new(core.entries).render
    rescue List::NotFoundOrAccessDeniedError => e
      puts e.message
    end
  end
end
