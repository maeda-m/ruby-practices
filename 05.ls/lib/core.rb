# frozen_string_literal: true

require 'forwardable'

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

    class FileStat
      extend Forwardable

      PERMISSIONS = {
        read: 'r',
        write: 'w',
        exec: 'x'
      }.freeze
      BLANK_MASK = '-'

      attr_reader :filename

      delegate %i[nlink size mtime gid uid] => :@stat

      def initialize(absolute_path)
        @filename = File.basename(absolute_path)
        @stat = File::Stat.new(absolute_path)
      end

      def file_type
        @stat.directory? ? 'd' : '-'
      end

      def permission
        # See: https://zenn.dev/universato/articles/20201202-z-mode
        # See: https://yu8as.hatenablog.com/entry/2018/11/20/130336
        mode = @stat.mode.to_s(8).scan(/\d{3,3}\z/).first
        to_mask(mode)
      end

      private

      def to_mask(mode)
        permissions = PERMISSIONS.values

        mode.chars.map do |octal_number|
          flags = format('%03b', octal_number).chars
          flags.map(&:to_i).map.with_index do |flag, i|
            flag.zero? ? BLANK_MASK : permissions[i]
          end
        end.flatten.join
      end
    end
  end
end
