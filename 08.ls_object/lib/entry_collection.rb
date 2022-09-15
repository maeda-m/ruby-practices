# frozen_string_literal: true

require 'forwardable'
require_relative 'file_stat'

module List
  class EntryCollection
    extend Forwardable

    delegate %i[empty? map] => :@entries

    def initialize(option)
      path = option.path

      if FileTest.file?(path)
        entries = [FileStat.new(path)]
      else
        # NOTE: ruby 3.1 から Dir.glob(path, File::FNM_DOTMATCH) は親ディレクトリ（ .. ）が含まれない
        # See: https://github.com/maeda-m/ruby-practices/pull/7#discussion_r848954812
        entries = Dir.entries(path).sort
        entries = entries.reverse if option.sort_reverse?
        entries = entries.reject(&method(:ignore?)) if option.ignore_minimal?

        entries = entries.map { |file_path| FileStat.new(File.join(path, file_path)) }
      end

      @entries = entries
    rescue Errno::EACCES, Errno::ENOENT
      # NOTE: Errno::EXXX ではユーザーの権限がない/存在しないの判断ができない
      message = "'#{path}' にアクセスできません"
      raise(NotFoundOrAccessDeniedError, message)
    end

    private

    def ignore?(file_path)
      dot_or_dot_dot = /\A\.{1,2}\z/.match?(file_path)
      dot_entry = file_path.start_with?('.')

      dot_or_dot_dot || dot_entry
    end
  end
end
