# frozen_string_literal: true

require 'debug'
require 'minitest/autorun'
require_relative 'bowling'

describe Bowling::Game do
  it 'スコアは 139 であること' do
    game = Bowling::Game.parse('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game.score
  end

  it 'スコアは 164 であること' do
    game = Bowling::Game.parse('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 164, game.score
  end

  it 'スコアは 107 であること' do
    game = Bowling::Game.parse('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 107, game.score
  end

  it 'スコアは 134 であること' do
    game = Bowling::Game.parse('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 134, game.score
  end

  it 'スコアは 144 であること' do
    game = Bowling::Game.parse('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
    assert_equal 144, game.score
  end

  it 'スコアは 300 であること' do
    game = Bowling::Game.parse('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, game.score
  end
end

describe Bowling::Frame do
  describe '1フレーム目がストライクの場合' do
    it 'スコアは 10 であること' do
      game = Bowling::Game.new

      first_frame = Bowling::Frame.new(1)
      first_frame.add_shot(10)
      first_frame.add_shot(0).exclude = true

      game.add_frame(first_frame)

      assert_equal 10, game.score
    end
  end

  describe '1フレーム目がスペアの場合' do
    it 'スコアは 10 であること' do
      game = Bowling::Game.new

      first_frame = Bowling::Frame.new(1)
      first_frame.add_shot(0)
      first_frame.add_shot(10)

      game.add_frame(first_frame)

      assert_equal 10, game.score
    end

    it 'スコアは 10 であること' do
      game = Bowling::Game.new

      first_frame = Bowling::Frame.new(1)
      first_frame.add_shot(1)
      first_frame.add_shot(9)

      game.add_frame(first_frame)

      assert_equal 10, game.score
    end
  end

  describe '1フレーム目がストライク、2フレーム目がスペアの場合' do
    it 'スコアは 30 であること' do
      game = Bowling::Game.new

      first_frame = Bowling::Frame.new(1)
      first_frame.add_shot(10)
      first_frame.add_shot(0).exclude = true

      second_frame = Bowling::Frame.new(2)
      second_frame.add_shot(2)
      second_frame.add_shot(8)

      game.add_frame(first_frame)
      game.add_frame(second_frame)

      assert_equal 30, game.score
    end

    it 'スコアは 30 であること' do
      game = Bowling::Game.new

      first_frame = Bowling::Frame.new(1)
      first_frame.add_shot(10)
      first_frame.add_shot(0).exclude = true

      second_frame = Bowling::Frame.new(2)
      second_frame.add_shot(0)
      second_frame.add_shot(10)

      game.add_frame(first_frame)
      game.add_frame(second_frame)

      assert_equal 30, game.score
    end
  end

  describe '1フレーム目と2フレーム目がストライクの場合、3フレーム目がガターの場合' do
    it 'スコアは 30 であること' do
      game = Bowling::Game.new

      first_frame = Bowling::Frame.new(1)
      first_frame.add_shot(10)
      first_frame.add_shot(0).exclude = true

      second_frame = Bowling::Frame.new(2)
      second_frame.add_shot(10)
      second_frame.add_shot(0).exclude = true

      third_frame = Bowling::Frame.new(3)
      third_frame.add_shot(0)
      third_frame.add_shot(0)

      game.add_frame(first_frame)
      game.add_frame(second_frame)
      game.add_frame(third_frame)

      assert_equal 30, game.score
    end
  end

  describe '1フレーム目がストライク、2フレーム目がスペア、3フレーム目がオープンフレームの場合' do
    it 'スコアは 37 であること' do
      game = Bowling::Game.new

      first_frame = Bowling::Frame.new(1)
      first_frame.add_shot(10)
      first_frame.add_shot(0).exclude = true

      second_frame = Bowling::Frame.new(2)
      second_frame.add_shot(4)
      second_frame.add_shot(6)

      third_frame = Bowling::Frame.new(3)
      third_frame.add_shot(0)
      third_frame.add_shot(7)

      game.add_frame(first_frame)
      game.add_frame(second_frame)
      game.add_frame(third_frame)

      assert_equal 37, game.score
    end

    it 'スコアは 42 であること' do
      game = Bowling::Game.new

      first_frame = Bowling::Frame.new(1)
      first_frame.add_shot(10)
      first_frame.add_shot(0).exclude = true

      second_frame = Bowling::Frame.new(2)
      second_frame.add_shot(4)
      second_frame.add_shot(6)

      third_frame = Bowling::Frame.new(3)
      third_frame.add_shot(3)
      third_frame.add_shot(6)

      game.add_frame(first_frame)
      game.add_frame(second_frame)
      game.add_frame(third_frame)

      assert_equal 42, game.score
    end
  end
end
