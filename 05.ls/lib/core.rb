# frozen_string_literal: true

require 'forwardable'
require 'etc'

module List
  class Core
    def initialize(option)
      @option = option
    end

    def entries
      directory_or_file_path = @option.path

      if FileTest.file?(directory_or_file_path)
        [FileStat.new(directory_or_file_path)]
      else
        directory_path = directory_or_file_path
        entries = Dir.entries(directory_path).sort
        entries = entries.reverse if @option.sort_reverse?
        entries = entries.reject(&method(:ignore?)) if @option.ignore_minimal?

        entries.map { |file_path| FileStat.new(File.join(directory_path, file_path)) }
      end
    rescue Errno::EACCES, Errno::ENOENT
      message = "'#{directory_or_file_path}' にアクセスできません"
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
      }
      BLANK_MASK = '-'
      ONLY_SUPER_USER_MASK = '000'

      delegate %i[size gsub ljust] => :basename

      def initialize(absolute_path)
        @absolute_path = absolute_path
        @stat = File::Stat.new(absolute_path)
      end

      def to_h
        {
          file_type: file_type,
          permission: permission,
          hardlink: @stat.nlink,
          owner_user_name: Etc.getpwuid(@stat.uid).name,
          owner_group_name: Etc.getgrgid(@stat.gid).name,
          bytesize: @stat.size,
          last_update_time: @stat.mtime.strftime('%-m月 %d %H:%M %Y'),
          filename: basename
        }
      end

      private

      def file_type
        @stat.directory? ? 'd' : '-'
      end

      def permission
        # See: https://zenn.dev/universato/articles/20201202-z-mode
        # See: https://yu8as.hatenablog.com/entry/2018/11/20/130336
        mode = @stat.mode.to_s(8).scan(/\d{3,3}\z/).first
        to_mask(mode)
      end

      def to_mask(mode)
        return no_permission if mode == ONLY_SUPER_USER_MASK

        mode.chars.map do |octal_number|
          binary_number = format('%#b', octal_number).gsub(/\A0b/, '')
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
        Array.new(3) { BLANK_MASK } * 3
      end

      def basename
        File.basename(@absolute_path)
      end
    end
  end
end
