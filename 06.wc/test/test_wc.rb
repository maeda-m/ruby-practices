# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
# rubocop:disable Layout/HeredocIndentation

require 'minitest/autorun'
require_relative '../wc'

describe 'main' do
  before do
    Dir.chdir(File.expand_path('../../05.ls', __dir__))
  end

  describe '単数ファイル指定（wc lib/command.rb）' do
    it '-l なし' do
      stdout = <<~STDOUT
      \  18  35 433 lib/command.rb
      STDOUT

      paths = %w[lib/command.rb]
      assert_output(stdout) { main(paths, without_byte_and_word: false) }
    end

    it '-l あり' do
      stdout = <<~STDOUT
      \  18 lib/command.rb
      STDOUT

      paths = %w[lib/command.rb]
      assert_output(stdout) { main(paths, without_byte_and_word: true) }
    end
  end

  describe '複数ファイル指定（wc lib/option.rb lib/core.rb lib/list.rb）' do
    it '-l なし' do
      stdout = <<~STDOUT
      \  47   98 1108 lib/option.rb
      \  34   63  814 lib/core.rb
      \   9   15  159 lib/list.rb
      \  90  176 2081 合計
      STDOUT

      paths = %w[lib/option.rb lib/core.rb lib/list.rb]
      assert_output(stdout) { main(paths, without_byte_and_word: false) }
    end

    it '-l あり' do
      stdout = <<~STDOUT
      \  47 lib/option.rb
      \  34 lib/core.rb
      \   9 lib/list.rb
      \  90 合計
      STDOUT

      paths = %w[lib/option.rb lib/core.rb lib/list.rb]
      assert_output(stdout) { main(paths, without_byte_and_word: true) }
    end
  end

  describe 'ワイルドカードでのファイル指定（wc lib/*.rb）' do
    it '-l なし' do
      stdout = <<~STDOUT
      \  18   35  433 lib/command.rb
      \  34   63  814 lib/core.rb
      \   9   15  159 lib/list.rb
      \  47   98 1108 lib/option.rb
      \ 108  211 2514 合計
      STDOUT

      paths = %w[lib/*.rb]
      assert_output(stdout) { main(paths, without_byte_and_word: false) }
    end

    it '-l あり' do
      stdout = <<~STDOUT
      \  18 lib/command.rb
      \  34 lib/core.rb
      \   9 lib/list.rb
      \  47 lib/option.rb
      \ 108 合計
      STDOUT

      paths = %w[lib/*.rb]
      assert_output(stdout) { main(paths, without_byte_and_word: true) }
    end
  end

  describe 'パイプなしの標準入力' do
    before do
      stdin = <<~STDIN
      1 2	3　4
      5  6\t\t\t7　　8

      \t
      9
      STDIN

      $stdin = StringIO.new(stdin)
    end

    it '-l なし' do
      stdout = <<~STDOUT
      \   5   9 31
      STDOUT

      assert_output(stdout) { main([], without_byte_and_word: false) }
    end

    it '-l あり' do
      stdout = <<~STDOUT
      \   5
      STDOUT

      assert_output(stdout) { main([], without_byte_and_word: true) }
    end
  end
end

# rubocop:enable Layout/HeredocIndentation
# rubocop:enable Metrics/BlockLength
