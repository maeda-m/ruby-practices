#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'stringio'

Row = Struct.new(:line_count, :word_count, :byte_count, :name)

def main(patterns, without_byte_and_word:)
  if patterns.empty?
    word_count_via_stdin(readlines.join, without_byte_and_word)
  else
    word_count_via_pattern(patterns, without_byte_and_word)
  end
end

def word_count_via_stdin(io, without_byte_and_word)
  row = generate_row(io, without_byte_and_word)
  render_rows(adjust_column([row]))
end

def word_count_via_pattern(patterns, without_byte_and_word)
  rows = []
  patterns.each do |pattern|
    Dir.glob(pattern).each do |path|
      File.open(path, 'r') do |f|
        rows << generate_row(f.read, without_byte_and_word, path)
      end
    end
  end

  rows << generate_footer(rows, without_byte_and_word) if rows.count >= 2
  render_rows(adjust_column(rows))
end

def generate_row(content, without_byte_and_word, path = nil)
  lines = content.split("\n")

  row = Row.new(lines.count)
  unless without_byte_and_word
    words = lines.map { |line| line.split(/[[:blank:]]+/).reject(&:empty?) }.flatten
    bytes = content.chars.map(&:bytesize)

    row.word_count = words.count
    row.byte_count = bytes.sum
  end
  row.name = path if path

  row
end

def generate_footer(rows, without_byte_and_word)
  line_count = rows.map(&:line_count).compact.sum

  footer = Row.new(line_count)
  unless without_byte_and_word
    footer.word_count = rows.map(&:word_count).compact.sum
    footer.byte_count = rows.map(&:byte_count).compact.sum
  end
  footer.name = '合計'

  footer
end

def adjust_column(rows)
  max_widths = calculate_max_widths(rows)

  rows.map do |row|
    row.to_h.each do |key, value|
      next if key == :name

      value = value.to_s
      next if value.empty?

      row[key] = value.rjust(max_widths[key])
    end

    row
  end
end

MIN_LINE_COUNT_WIDTH = 4
MIN_WORD_COUNT_WIDTH = 2
PADDING_WORD_COUNT = 1

def calculate_max_widths(rows)
  line_count_width = [MIN_LINE_COUNT_WIDTH, rows.map(&:line_count).max.to_s.size].max
  word_count_width = [MIN_WORD_COUNT_WIDTH, rows.map(&:word_count).compact.max.to_s.size].max
  byte_count_width = rows.map(&:byte_count).compact.max.to_s.size

  {
    line_count: line_count_width,
    word_count: word_count_width + PADDING_WORD_COUNT,
    byte_count: byte_count_width
  }
end

def render_rows(rows)
  rows = rows.map { |row| row.values.compact.reject(&:empty?).join(' ') }
  puts rows.join("\n")
end

if __FILE__ == $PROGRAM_NAME
  lines_option = ARGV.getopts('l').values.first
  paths = ARGV

  main(paths, without_byte_and_word: lines_option)
end
