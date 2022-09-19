# frozen_string_literal: true

require 'etc'
require 'forwardable'

module List
  class FileStat
    extend Forwardable

    PERMISSIONS = {
      read: 'r',
      write: 'w',
      exec: 'x'
    }.freeze
    BLANK_MASK = '-'

    delegate %i[size nlink mtime] => :@stat
    alias actual_link_count nlink
    alias modified_time mtime

    attr_reader :filename, :linkname

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

    def user
      Etc.getpwuid(@stat.uid).name
    end

    def group
      Etc.getgrgid(@stat.gid).name
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
