# frozen_string_literal: true

module List
  class ColumnLayout
    MAX_COLUMN_SIZE = 3
    DEFAULT_MARGIN_WIDTH = 3

    attr_reader :entries

    def initialize(entries)
      @entries = entries
    end

    def render
      if entries.empty?
        puts ''
      else
        rows = generate_rows(entries)
        puts render_rows(rows)
      end
    end

    private

    def render_rows(rows)
      rows.map(&:join).map(&:strip).join("\n")
    end

    def generate_rows(entries)
      max_row_size = (entries.size.to_f / MAX_COLUMN_SIZE).ceil

      columns = entries.each_slice(max_row_size).map do |column|
        blank_factors = Array.new(max_row_size - column.size) { '' }
        # NOTE: サイズが不揃いな配列にならないように空要素を追加している
        column + blank_factors
      end

      transpose_with_ljust_columns(columns)
    end

    def transpose_with_ljust_columns(columns)
      columns = columns.map do |column|
        max_width = column.map { |file_path| string_width_with_multibyte(file_path) }.max
        max_width += DEFAULT_MARGIN_WIDTH

        column.map { |file_path| ljust_with_multibyte(file_path, max_width) }
      end

      columns.transpose
    end

    def string_width_with_multibyte(str)
      str.size + multibyte_char_count(str)
    end

    def ljust_with_multibyte(str, width, padding = ' ')
      width -= multibyte_char_count(str)

      str.ljust(width, padding)
    end

    def multibyte_char_count(str)
      # See: https://github.com/k-takata/Onigmo/blob/master/doc/RE.ja
      # See: https://github.com/k-takata/Onigmo/blob/master/doc/UnicodeProps.txt
      str.gsub(/[ｧ-ﾝﾞﾟ]/, ' ').scan(/[\p{Hiragana}|\p{Katakana}|\p{Han}]/).size
    end
  end
end
