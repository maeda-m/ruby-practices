# frozen_string_literal: true

require 'forwardable'

module List
  class Core
    extend Forwardable

    def initialize(option)
      @option = option
    end

    def entries
      path = @option.path

      if FileTest.file?(path)
        [File.basename(path)]
      else
        entries = Dir.entries(path).sort
        return entries unless @option.ignore_minimal?

        entries.reject(&method(:ignore?))
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
