# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'minitest/autorun'
require_relative '../ls'

describe List::Command do
  before do
    tmp_dir_path = Dir.mktmpdir

    file_path = File.join(tmp_dir_path, '.ignore')
    File.open(file_path, 'w', 0o644) { |f| f.write('') }
    FileUtils.touch(file_path, mtime: Time.new(1999, 1, 1, 1, 1, 1))

    File.write(File.join(tmp_dir_path, '001.txt'), '')
    File.write(File.join(tmp_dir_path, '002.txt'), '')
    File.write(File.join(tmp_dir_path, '003.txt'), '')
    File.write(File.join(tmp_dir_path, '004.txt'), '')
    File.write(File.join(tmp_dir_path, '005.txt'), '')

    file_path = File.join(tmp_dir_path, '006-ﾆﾎﾝｺﾞ.txt')
    File.write(file_path, '')
    FileUtils.chmod(0o577, file_path)
    FileUtils.touch(file_path, mtime: Time.new(2111, 11, 22, 3, 4, 5))

    file_path = File.join(tmp_dir_path, '008.txt')
    File.open(file_path, 'w', 0o600) { |f| f.write('0123456789') }
    FileUtils.touch(file_path, mtime: Time.new(2000, 12, 31, 23, 59, 0))

    file_path = File.join(tmp_dir_path, '009.txt')
    File.open(file_path, 'w', 0o754) { |f| f.write('123') }
    FileUtils.touch(file_path, mtime: Time.new(2199, 9, 9, 9, 9, 9))

    file_path = File.join(tmp_dir_path, '010.txt')
    File.write(file_path, '12345')
    FileUtils.chmod(0o321, file_path)
    FileUtils.touch(file_path, mtime: Time.new(2188, 8, 8, 8, 8, 8))

    file_path = File.join(tmp_dir_path, '011.txt')
    File.open(file_path, 'w', 0o000) { |f| f.write('にほんご') }
    FileUtils.touch(file_path, mtime: Time.new(2177, 7, 7, 7, 7, 7))

    child_dir_path = File.join(tmp_dir_path, '007-日本語のディレクトリ')
    Dir.mkdir(child_dir_path)
    File.write(File.join(child_dir_path, '001.txt'), '')
    File.write(File.join(child_dir_path, '002.txt'), '')
    Dir.mkdir(File.join(child_dir_path, '003-日本語'))
    File.write(File.join(child_dir_path, '004.txt'), '')
    File.write(File.join(child_dir_path, '005.txt'), '')
    FileUtils.touch(child_dir_path, mtime: Time.new(2122, 2, 22, 22, 22, 22))

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
        assert_output('') { List::Command.run(option) }
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

  describe 'オプション -r ありのls' do
    describe 'ディレクトリ・ファイル指定なし' do
      it 'ファイルとディレクトリの一覧が最大3列で表示されること' do
        stdout = <<~STDOUT
          011.txt   007-日本語のディレクトリ   003.txt
          010.txt   006-ﾆﾎﾝｺﾞ.txt              002.txt
          009.txt   005.txt                    001.txt
          008.txt   004.txt
        STDOUT

        option = List::Option.new(['-r'])
        assert_output(stdout) { List::Command.run(option) }
      end
    end

    describe 'ディレクトリ指定あり' do
      it 'ファイルとディレクトリの一覧が最大3列で表示されること' do
        stdout = <<~STDOUT
          005.txt   003-日本語   001.txt
          004.txt   002.txt
        STDOUT

        option = List::Option.new(['-r', @child_dir_path])
        assert_output(stdout) { List::Command.run(option) }
      end
    end

    describe 'オプション -a を追加した場合' do
      it 'ファイル（隠しファイルあり）とディレクトリの一覧が最大3列で表示されること' do
        stdout = <<~STDOUT
          005.txt      002.txt   .
          004.txt      001.txt
          003-日本語   ..
        STDOUT

        option = List::Option.new(['-ra', @child_dir_path])
        assert_output(stdout) { List::Command.run(option) }
      end
    end
  end

  describe 'オプション -l ありのls' do
    before do
      FileUtils.remove_entry_secure(File.join(@tmp_dir_path, '001.txt'))
      FileUtils.remove_entry_secure(File.join(@tmp_dir_path, '002.txt'))
      FileUtils.remove_entry_secure(File.join(@tmp_dir_path, '003.txt'))
      FileUtils.remove_entry_secure(File.join(@tmp_dir_path, '004.txt'))
      FileUtils.remove_entry_secure(File.join(@tmp_dir_path, '005.txt'))

      @last_update_time = Time.now.strftime('%m月 %d %H:%M %Y')
      File.symlink('008.txt', '012-softlink.txt')
    end

    describe 'ディレクトリ・ファイル指定なし' do
      it 'ファイルとディレクトリの一覧が最大1列で表示されること' do
        stdout = <<~STDOUT
          -r-xrwxrwx 1 maeda-m maeda-m    0 11月 22 03:04 2111 006-ﾆﾎﾝｺﾞ.txt
          drwxr-xr-x 3 maeda-m maeda-m 4096 02月 22 22:22 2122 007-日本語のディレクトリ
          -rw------- 1 maeda-m maeda-m   10 12月 31 23:59 2000 008.txt
          -rwxr-xr-- 1 maeda-m maeda-m    3 09月 09 09:09 2199 009.txt
          --wx-w---x 1 maeda-m maeda-m    5 08月 08 08:08 2188 010.txt
          ---------- 1 maeda-m maeda-m   12 07月 07 07:07 2177 011.txt
          lrwxrwxrwx 1 maeda-m maeda-m    7 #{@last_update_time} 012-softlink.txt -> 008.txt
        STDOUT

        option = List::Option.new(['-l'])
        assert_output(stdout) { List::Command.run(option) }
      end
    end

    describe 'オプション -r を追加した場合' do
      it 'ファイル（隠しファイルあり）とディレクトリの一覧が最大1列で逆順表示されること' do
        stdout = <<~STDOUT
          lrwxrwxrwx 1 maeda-m maeda-m    7 #{@last_update_time} 012-softlink.txt -> 008.txt
          ---------- 1 maeda-m maeda-m   12 07月 07 07:07 2177 011.txt
          --wx-w---x 1 maeda-m maeda-m    5 08月 08 08:08 2188 010.txt
          -rwxr-xr-- 1 maeda-m maeda-m    3 09月 09 09:09 2199 009.txt
          -rw------- 1 maeda-m maeda-m   10 12月 31 23:59 2000 008.txt
          drwxr-xr-x 3 maeda-m maeda-m 4096 02月 22 22:22 2122 007-日本語のディレクトリ
          -r-xrwxrwx 1 maeda-m maeda-m    0 11月 22 03:04 2111 006-ﾆﾎﾝｺﾞ.txt
        STDOUT

        option = List::Option.new(['-lr'])
        assert_output(stdout) { List::Command.run(option) }
      end
    end

    describe 'オプション -a を追加した場合' do
      it 'ファイル（隠しファイルあり）とディレクトリの一覧が最大1列で表示されること' do
        option = List::Option.new(['-la'])
        out, = capture_io { List::Command.run(option) }
        lines = out.split("\n")

        assert_equal(10, lines.size)
        assert_match(/\Adrwx------\s+\d+ maeda-m maeda-m\s+\d+ \d{2,2}月 \d{2,2} \d{2,2}:\d{2,2} \d{4,4} \.\z/, lines[0])
        assert_match(/\Adrwxrwxrwx\s+\d+ root    root   \s+\d+ \d{2,2}月 \d{2,2} \d{2,2}:\d{2,2} \d{4,4} \.\.\z/, lines[1])
        assert_match(/\A-rw-r--r--\s+1 maeda-m maeda-m\s+0 01月 01 01:01 1999 \.ignore\z/, lines[2])
        assert_match(/\A-r-xrwxrwx\s+1 maeda-m maeda-m\s+0 11月 22 03:04 2111 006-ﾆﾎﾝｺﾞ\.txt\z/, lines[3])
        assert_match(/\Alrwxrwxrwx\s+1 maeda-m maeda-m\s+7 #{@last_update_time} 012-softlink\.txt -> 008\.txt\z/, lines[9])
      end
    end

    describe 'オプション -ar を追加した場合' do
      it 'ファイル（隠しファイルあり）とディレクトリの一覧が最大1列で表示されること' do
        option = List::Option.new(['-lar'])
        out, = capture_io { List::Command.run(option) }
        lines = out.split("\n")

        assert_equal(10, lines.size)
        assert_match(/\Alrwxrwxrwx\s+1 maeda-m maeda-m\s+7 #{@last_update_time} 012-softlink\.txt -> 008\.txt\z/, lines[0])
        assert_match(/\A-r-xrwxrwx\s+1 maeda-m maeda-m\s+0 11月 22 03:04 2111 006-ﾆﾎﾝｺﾞ\.txt\z/, lines[6])
        assert_match(/\A-rw-r--r--\s+1 maeda-m maeda-m\s+0 01月 01 01:01 1999 \.ignore\z/, lines[7])
        assert_match(/\Adrwxrwxrwx\s+\d+ root    root   \s+\d+ \d{2,2}月 \d{2,2} \d{2,2}:\d{2,2} \d{4,4} \.\.\z/, lines[8])
        assert_match(/\Adrwx------\s+\d+ maeda-m maeda-m\s+\d+ \d{2,2}月 \d{2,2} \d{2,2}:\d{2,2} \d{4,4} \.\z/, lines[9])
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
