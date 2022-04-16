# frozen_string_literal: true

require_relative 'core'
require_relative 'layout/column_layout'
require_relative 'layout/long_layout'

module List
  module Command
    def self.run(option)
      entries = List::Core.new(option).entries

      layout_class = option.long_format? ? LongLayout : ColumnLayout
      layout_class.new(entries).render
    rescue List::NotFoundOrAccessDeniedError => e
      puts e.message
    end
  end
end
