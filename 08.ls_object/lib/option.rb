# frozen_string_literal: true

require 'optparse'

module List
  class Option
    IGNORE_MODE_MINIMAL = :ignore_minimal

    attr_reader :path

    def initialize(argv)
      @ignore_mode = IGNORE_MODE_MINIMAL
      @sort_reverse = false
      @long_format = false

      optparse = OptionParser.new do |opts|
        opts.banner = 'Usage: ls.rb [OPTION] [PATH]'

        opts.separator ''
        opts.separator 'Options:'

        opts.on('-a', '--all', '. で始まる要素を無視しない') { @ignore_mode = nil }
        opts.on('-r', '--reverse', 'ソート順を反転させる') { @sort_reverse = true }
        opts.on('-l', '', '詳細リスト形式で表示する') { @long_format = true }

        opts.on_tail('-h', '--help', 'この使い方を表示して終了する') do
          puts opts
          exit 1
        end
      end
      optparse.parse!(argv)
      @path = argv.first || Dir.pwd
    end

    def ignore_minimal?
      @ignore_mode == IGNORE_MODE_MINIMAL
    end

    def sort_reverse?
      @sort_reverse
    end

    def long_format?
      @long_format
    end
  end
end
