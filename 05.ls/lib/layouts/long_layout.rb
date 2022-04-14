# frozen_string_literal: true

require_relative 'abstract_layout'

module List
  class LongLayout < AbstractLayout
    def render
      rows = entries.map(&:to_h).map do |attrs|
        [
          "#{attrs[:file_type]}#{attrs[:permission]}",
          attrs[:hardlink],
          attrs[:owner_user_name],
          attrs[:owner_group_name],
          attrs[:bytesize].to_s.rjust(4),
          attrs[:last_update_time].strftime('%-m月 %d %H:%M %Y').rjust(17),
          attrs[:filename],
        ].join(' ')
      end
      puts rows.join("\n")
    end
  end
end
