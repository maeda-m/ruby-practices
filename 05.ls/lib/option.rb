# frozen_string_literal: true

require 'optparse'

module List
  class Option
    attr_reader :path, :ignore_mode, :format, :sort_type

    def initialize(argv, default_path = Dir.pwd)
      @optparse = OptionParser.new do |opts|
        opts.banner = 'Usage: ls.rb [OPTION] [PATH]'

        opts.separator ''
        opts.separator 'Options:'

        opts.on('-a', '--all', '. で始まる要素を無視しない') { @ignore_mode = :ignore_minimal }
        opts.on('-l', '', '詳細リスト形式で表示する') { @format = :long_format }
        opts.on('-r', '--reverse', 'ソート順を反転させる') { @sort_type = :sort_reverse }

        opts.on_tail('-h', '--help', 'この使い方を表示して終了する') do
          puts opts
          exit 1
        end
      end
      @optparse.parse!(argv)
      @path = argv.first || default_path
    end

    def core_options
      {
        ignore_mode: self.ignore_mode,
      }
    end

    def render_options
      {
        format: self.format,
        sort_type: self.sort_type,
      }
    end
  end
end
