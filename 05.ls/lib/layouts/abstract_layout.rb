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
