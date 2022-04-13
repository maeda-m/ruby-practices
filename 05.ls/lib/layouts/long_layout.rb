# frozen_string_literal: true

require_relative 'abstract_layout'

module List
  class LongLayout < AbstractLayout
    def render
      rows = entries.map(&:to_h).map(&:values)
      puts rows.map { |row| row.join(' ') } .join("\n")
    end
  end
end
