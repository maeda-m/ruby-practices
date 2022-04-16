# frozen_string_literal: true

require_relative 'core/file_stat'

module List
  class Core
    def initialize(option)
      @option = option
    end

    def entries
      path = @option.path

      if FileTest.file?(path)
        [FileStat.new(path)]
      else
        entries = Dir.entries(path).sort
        entries = entries.reverse if @option.sort_reverse?
        entries = entries.reject(&method(:ignore?)) if @option.ignore_minimal?

        entries.map { |file_path| FileStat.new(File.join(path, file_path)) }
      end
    rescue Errno::EACCES, Errno::ENOENT
      message = "'#{path}' にアクセスできません"
      raise(NotFoundOrAccessDeniedError, message)
    end

    private

    def ignore?(file_path)
      /\A\.{1,2}\z/.match?(file_path) || file_path.start_with?('.')
    end
  end
end
