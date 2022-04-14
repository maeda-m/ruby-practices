# frozen_string_literal: true

module List
  class AbstractLayout
    attr_reader :entries

    def initialize(entries)
      @entries = entries
    end

    def render
      raise 'This is a method of an abstract class. Override it with your inheritance.'
    end

    private

    def render_rows(rows)
      rows.map(&:join).map(&:strip).join("\n")
    end

    def adjust_column(column, margin_width)
      only_integer_column = column.compact.all? { |obj| obj.is_a?(Integer) }
      if only_integer_column
        rjust_column(column.map(&:to_s), margin_width)
      else
        ljust_column(column, margin_width)
      end
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
