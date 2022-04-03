# frozen_string_literal: true

module List
  class Rendering
    DEFAULT_MARGIN_BYTESIZE = 3

    attr_reader :options

    def initialize(options)
      # NOTE: options は "lsコマンドを作る1：オプション無しのlsを作る" では使用しない
      @options = options
    end

    def render(entries)
      if entries.empty?
        puts ''
        return
      end

      max_row_size, mod = entries.size.divmod(List::MAX_COLUMN_COUNT)
      max_row_size += 1 unless mod.zero?

      columns = []
      entries.each_slice(max_row_size) do |column|
        blank_factors = Array.new(max_row_size - column.size) { '' }
        columns << column + blank_factors
      end

      puts render_rows(columns)
    end

    private

    def render_rows(columns)
      columns = columns.map do |column|
        max_bytesize = max_bytesize_with_multi_byte(column) + DEFAULT_MARGIN_BYTESIZE
        column.map { |file_path| ljust_with_multi_byte(file_path, max_bytesize) }
      end

      rows = columns.transpose
      rows.map(&:join).map(&:strip).join("\n")
    end

    def ljust_with_multi_byte(str, bytesize, padding = ' ')
      str.ljust(bytesize, padding)
    end

    def max_bytesize_with_multi_byte(column)
      column.map { |file_path| bytesize_with_multi_byte(file_path) }.max
    end

    def bytesize_with_multi_byte(str)
      # See: https://github.com/k-takata/Onigmo/blob/master/doc/RE.ja
      # See: https://github.com/k-takata/Onigmo/blob/master/doc/UnicodeProps.txt
      str = str.gsub(/[ｧ-ﾝﾞﾟ]/, ' ')
      multi_byte_count = str.scan(/[\p{Hiragana}|\p{Katakana}|\p{Han}]/).size
      str.bytesize - (2 * multi_byte_count)
    end
  end
end
