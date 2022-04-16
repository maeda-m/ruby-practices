# frozen_string_literal: true

require 'forwardable'

module List
  class Core
    class FileStat
      extend Forwardable

      PERMISSIONS = {
        read: 'r',
        write: 'w',
        exec: 'x'
      }.freeze
      BLANK_MASK = '-'

      attr_reader :filename, :linkname

      delegate %i[nlink size mtime gid uid] => :@stat

      def initialize(absolute_path)
        @filename = File.basename(absolute_path)

        if FileTest.symlink?(absolute_path)
          @stat = File.lstat(absolute_path)
          @linkname = File.readlink(absolute_path)
        else
          @stat = File.stat(absolute_path)
        end
      end

      def file_type
        return 'd' if @stat.directory?
        return 'l' if @stat.symlink?

        '-'
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
