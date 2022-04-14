# frozen_string_literal: true

require_relative 'abstract_layout'

module List
  class ColumnLayout < AbstractLayout
    MAX_COLUMN_SIZE = 3
    DEFAULT_MARGIN_WIDTH = 3

    def render
      filenames = entries.map(&:filename)
      max_row_size = (filenames.size.to_f / MAX_COLUMN_SIZE).ceil

      columns = filenames.each_slice(max_row_size).map do |column|
        blank_factors = Array.new(max_row_size - column.size) { '' }
        # NOTE: サイズが不揃いな配列にならないように空要素を追加している
        column + blank_factors
      end

      rows = columns.map { |column| adjust_column(column, DEFAULT_MARGIN_WIDTH) }.transpose
      puts render_rows(rows)
    end
  end
end
