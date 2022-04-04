# frozen_string_literal: true

require 'optparse'

module List
  class Option
    attr_reader :path

    def initialize(argv, default_path = Dir.pwd)
      @optparse = OptionParser.new do |opts|
        opts.banner = 'Usage: ls.rb [OPTION] [PATH]'

        opts.separator ''
        opts.separator 'Options:'

        opts.on_tail('-h', '--help', 'この使い方を表示して終了する') do
          puts opts
          exit 1
        end
      end
      @optparse.parse!(argv)
      @path = argv.first || default_path
    end
  end
end
