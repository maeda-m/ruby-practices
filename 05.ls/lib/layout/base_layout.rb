# frozen_string_literal: true

module List
  class BaseLayout
    attr_reader :entries

    def initialize(entries)
      @entries = entries
    end

    def render
      if entries.empty?
        puts ''
      else
        columns = generate_columns(entries)
        columns = adjust_columns(columns)
        rows = columns.transpose

        puts rows.map(&:join).map(&:strip).join("\n")
      end
    end

    private

    def generate_columns(_entries)
      raise NotImplementedError
    end

    def adjust_columns(_columns)
      raise NotImplementedError
    end

    def rjust_column(column, margin_width)
      max_width = column.map(&:size).max
      width_with_margin = max_width + margin_width
      column.map { |str| str.rjust(max_width).ljust(width_with_margin) }
    end

    def ljust_column(column, margin_width)
      max_width = column.map { |str| string_width_with_multibyte(str) }.max
      width_with_margin = max_width + margin_width
      column.map { |str| str.ljust(width_with_margin - multibyte_char_count(str)) }
    end

    def string_width_with_multibyte(str)
      str.size + multibyte_char_count(str)
    end

    def multibyte_char_count(str)
      # See: https://github.com/k-takata/Onigmo/blob/master/doc/RE.ja
      # See: https://github.com/k-takata/Onigmo/blob/master/doc/UnicodeProps.txt
      str.gsub(/[ｧ-ﾝﾞﾟ]/, ' ').scan(/[\p{Hiragana}|\p{Katakana}|\p{Han}]/).size
    end
  end
end
