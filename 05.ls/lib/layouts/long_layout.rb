# frozen_string_literal: true

require 'etc'
require_relative 'abstract_layout'

module List
  class LongLayout < AbstractLayout
    DEFAULT_MARGIN_WIDTH = 1

    def render
      rows = entries.map do |entry|
        [
          entry.file_type + entry.permission,
          entry.nlink,
          Etc.getpwuid(entry.uid).name,
          Etc.getgrgid(entry.gid).name,
          entry.size,
          entry.mtime.strftime('%m月 %d %H:%M %Y'),
          entry.filename
        ]
      end

      rows = rows.transpose.map { |column| adjust_column(column, DEFAULT_MARGIN_WIDTH) }.transpose
      puts render_rows(rows)
    end
  end
end
