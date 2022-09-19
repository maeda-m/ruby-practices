# frozen_string_literal: true

require_relative 'base_layout'

module List
  class ColumnLayout < BaseLayout
    MAX_COLUMN_SIZE = 3
    DEFAULT_MARGIN_WIDTH = 3

    private

    def generate_columns(entries)
      filenames = entries.map(&:filename)
      max_row_size = (filenames.size.to_f / MAX_COLUMN_SIZE).ceil

      filenames.each_slice(max_row_size).map do |column|
        blank_factors = Array.new(max_row_size - column.size) { '' }
        # NOTE: サイズが不揃いな配列にならないように空要素を追加している
        column + blank_factors
      end
    end

    def adjust_columns(columns)
      columns.map { |column| ljust_column(column, DEFAULT_MARGIN_WIDTH) }
    end
  end
end
