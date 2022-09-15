# frozen_string_literal: true

require_relative 'base_layout'

module List
  class LongLayout < BaseLayout
    DEFAULT_MARGIN_WIDTH = 1

    private

    def generate_columns(entries)
      rows = entries.map do |entry|
        [
          entry.file_type + entry.permission,
          entry.actual_link_count,
          entry.user,
          entry.group,
          entry.size,
          entry.modified_time.strftime('%_m %_d %H:%M %Y'),
          [entry.filename, entry.linkname].compact.join(' -> ')
        ]
      end

      rows.transpose
    end

    def adjust_columns(columns)
      columns.map do |column|
        # NOTE: 数値の場合は右寄せ
        only_integer_column = column.compact.all? { |obj| obj.is_a?(Integer) }
        if only_integer_column
          rjust_column(column.map(&:to_s), DEFAULT_MARGIN_WIDTH)
        else
          ljust_column(column, DEFAULT_MARGIN_WIDTH)
        end
      end
    end
  end
end
