# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'minitest/autorun'
require_relative '../ls'

describe List::Command do
  before do
    tmp_dir_path = Dir.mktmpdir

    File.write(File.join(tmp_dir_path, '.ignore'), '')
    File.write(File.join(tmp_dir_path, '001.txt'), '')
    File.write(File.join(tmp_dir_path, '002.txt'), '')
    File.write(File.join(tmp_dir_path, '003.txt'), '')
    File.write(File.join(tmp_dir_path, '004.txt'), '')
    File.write(File.join(tmp_dir_path, '005.txt'), '')
    File.write(File.join(tmp_dir_path, '006-ﾆﾎﾝｺﾞ.txt'), '')
    File.write(File.join(tmp_dir_path, '008.txt'), '')
    File.write(File.join(tmp_dir_path, '009.txt'), '')
    File.write(File.join(tmp_dir_path, '010.txt'), '')
    File.write(File.join(tmp_dir_path, '011.txt'), '')

    child_dir_path = File.join(tmp_dir_path, '007-日本語のディレクトリ')
    Dir.mkdir(child_dir_path)
    File.write(File.join(child_dir_path, '001.txt'), '')
    File.write(File.join(child_dir_path, '002.txt'), '')
    Dir.mkdir(File.join(child_dir_path, '003-日本語'))
    File.write(File.join(child_dir_path, '004.txt'), '')
    File.write(File.join(child_dir_path, '005.txt'), '')

    Dir.chdir(tmp_dir_path)
    @tmp_dir_path = tmp_dir_path
    @child_dir_path = child_dir_path
  end

  after do
    FileUtils.remove_entry_secure(@tmp_dir_path)
  end

  describe 'オプション無しのls' do
    describe 'ディレクトリ・ファイル指定なし' do
      it 'ファイルとディレクトリの一覧が最大3列で表示されること' do
        stdout = <<~STDOUT
          001.txt   005.txt                    009.txt
          002.txt   006-ﾆﾎﾝｺﾞ.txt              010.txt
          003.txt   007-日本語のディレクトリ   011.txt
          004.txt   008.txt
        STDOUT

        option = List::Option.new([])
        assert_output(stdout) { List::Command.run(option) }
      end
    end

    describe 'ディレクトリ指定あり' do
      it 'ファイルとディレクトリの一覧が最大3列で表示されること' do
        stdout = <<~STDOUT
          001.txt   003-日本語   005.txt
          002.txt   004.txt
        STDOUT

        option = List::Option.new([@child_dir_path])
        assert_output(stdout) { List::Command.run(option) }
      end

      it '空ディレクトリを指定した場合は何も表示されないこと' do
        empty_dir_path = File.join(@child_dir_path, '003-日本語')
        option = List::Option.new([empty_dir_path])
        assert_output("\n") { List::Command.run(option) }
      end

      it '存在しないディレクトリを指定した場合はエラーが表示されること' do
        option = List::Option.new(['./not-exist-directory'])
        stdout = "'./not-exist-directory' にアクセスできません\n"
        assert_output(stdout) { List::Command.run(option) }
      end

      it '権限がないディレクトリを指定した場合はエラーが表示されること' do
        option = List::Option.new(['/root/'])
        stdout = "'/root/' にアクセスできません\n"
        assert_output(stdout) { List::Command.run(option) }
      end
    end

    describe 'ファイル指定あり' do
      it 'ファイル一覧が表示されること' do
        file_path = File.join(@child_dir_path, '002.txt')
        option = List::Option.new([file_path])
        assert_output("002.txt\n") { List::Command.run(option) }
      end

      it '存在しないファイルを指定した場合はエラーが表示されること' do
        option = List::Option.new(['./not-exist-file.yml'])
        stdout = "'./not-exist-file.yml' にアクセスできません\n"
        assert_output(stdout) { List::Command.run(option) }
      end

      it '権限がないファイルを指定した場合はエラーが表示されること' do
        option = List::Option.new(['/root/.bashrc'])
        stdout = "'/root/.bashrc' にアクセスできません\n"
        assert_output(stdout) { List::Command.run(option) }
      end
    end
  end

  describe 'オプション -a ありのls' do
    describe 'ディレクトリ・ファイル指定なし' do
      it 'ファイルとディレクトリの一覧が最大3列で表示されること' do
        stdout = <<~STDOUT
          .         003.txt                    008.txt
          ..        004.txt                    009.txt
          .ignore   005.txt                    010.txt
          001.txt   006-ﾆﾎﾝｺﾞ.txt              011.txt
          002.txt   007-日本語のディレクトリ
        STDOUT

        option = List::Option.new(['-a'])
        assert_output(stdout) { List::Command.run(option) }
      end
    end

    describe 'ディレクトリ指定あり' do
      it 'ファイルとディレクトリの一覧が最大3列で表示されること' do
        stdout = <<~STDOUT
          .         002.txt      005.txt
          ..        003-日本語
          001.txt   004.txt
        STDOUT

        option = List::Option.new(['-a', @child_dir_path])
        assert_output(stdout) { List::Command.run(option) }
      end

      it '空ディレクトリを指定した場合は親およびカレントディレクトリのみが表示されること' do
        empty_dir_path = File.join(@child_dir_path, '003-日本語')
        option = List::Option.new(['-a', empty_dir_path])
        assert_output(".   ..\n") { List::Command.run(option) }
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
