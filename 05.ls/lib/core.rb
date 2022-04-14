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
      ONLY_SUPER_USER_MASK = '000'

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
        return no_permission if mode == ONLY_SUPER_USER_MASK

        mode.chars.map do |octal_number|
          binary_number = format('%#b', octal_number).delete_prefix('0b')
          PERMISSIONS.values.map.with_index do |symbol, i|
            if binary_number[i].to_i.zero?
              BLANK_MASK
            else
              symbol
            end
          end
        end.flatten.join
      end

      def no_permission
        BLANK_MASK * 3 * 3
      end
    end
  end
end
