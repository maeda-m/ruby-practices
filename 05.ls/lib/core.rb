# frozen_string_literal: true

module List
  class Core
    attr_reader :path, :options

    def initialize(path, options)
      @path = path
      # NOTE: options は "lsコマンドを作る1：オプション無しのlsを作る" では使用しない
      @options = options
    end

    def entries
      if FileTest.file?(path)
        [File.basename(path)]
      else
        Dir.entries(path).reject(&method(:ignore?)).sort
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
