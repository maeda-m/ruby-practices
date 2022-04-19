#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'stringio'

Message = Struct.new(:message)
Row = Struct.new(:line_count, :word_count, :byte_count, :note)

def main(patterns, without_byte_and_word:)
  rows = []
  if patterns.empty?
    io = StringIO.new(readlines.join)
    rows << generate_row(io, without_byte_and_word)
  else
    patterns.each do |pattern|
      Dir.glob(pattern).each do |path|
        file = File.open(path, 'r')
        rows << generate_row(file, without_byte_and_word, path)
      end
    end
  end

  if rows.count >= 2
    rows_without_message = rows.reject { |row| row.is_a?(Message) }
    line_count = rows_without_message.map(&:line_count).compact.sum

    footer = Row.new(line_count, nil, nil, '合計')
    footer.word_count = rows_without_message.map(&:word_count).compact.sum unless without_byte_and_word
    footer.byte_count = rows_without_message.map(&:byte_count).compact.sum unless without_byte_and_word

    rows << footer
  end

  rows = adjust_column(rows)
  puts rows.join("\n")
end

def generate_row(file, without_byte_and_word, path = nil)
  content = file.read

  lines = content.split("\n")
  words = lines.map { |line| line.split(/[[:blank:]]+/) }.flatten
  words = words.compact.reject(&:empty?)
  bytes = content.chars.map(&:bytesize)

  row = Row.new(lines.count)
  row.word_count = words.count unless without_byte_and_word
  row.byte_count = bytes.sum unless without_byte_and_word
  row.note = path if path

  row
ensure
  file.close
end

def adjust_column(rows_with_message)
  rows = rows_with_message.reject { |row| row.is_a?(Message) }
  max_line_width = [4, rows.map(&:line_count).max.to_s.size, 4].max
  max_word_width = [2, rows.map(&:word_count).compact.max.to_s.size].max + 1
  max_byte_width = rows.map(&:byte_count).compact.max.to_s.size

  rows_with_message.map do |row|
    if row.is_a?(Message)
      row.message
    else
      [
        row.line_count.to_s.rjust(max_line_width),
        row.word_count.to_s.then { |s| s.empty? ? nil : s.rjust(max_word_width) },
        row.byte_count.to_s.then { |s| s.empty? ? nil : s.rjust(max_byte_width) },
        row.note
      ].compact.reject(&:empty?).join(' ')
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  lines_option = ARGV.getopts('l').values.first
  paths = ARGV

  main(paths, without_byte_and_word: lines_option)
end
