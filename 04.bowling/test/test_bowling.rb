# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../bowling'

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

  it 'スコアは 0 であること' do
    game = Bowling::Game.parse('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
    assert_equal 0, game.score
  end

  it 'スコアは 144 であること' do
    game = Bowling::Game.parse('1,9,2,8,3,7,4,6,5,5,6,4,7,3,8,2,9,1,0,10,0')
    assert_equal 144, game.score
  end
end

describe Bowling::Frame do
  describe '1フレーム目がストライクの場合' do
    before do
      @first_frame = Bowling::Frame.new
      @first_frame.add_strike_shot
    end

    describe '2フレーム目がストライクの場合' do
      describe '3フレーム目がガターの場合' do
        it 'スコアは 30 であること' do
          second_frame = Bowling::Frame.new(@first_frame)
          second_frame.add_strike_shot

          third_frame = Bowling::Frame.new(second_frame)
          third_frame.add_shot(0)
          third_frame.add_shot(0)

          frames = [
            @first_frame,
            second_frame,
            third_frame
          ]

          assert_equal 30, frames.sum(&:score)
        end
      end
    end

    describe '2フレーム目がスペアの場合' do
      describe '3フレーム目がオープンフレームの場合' do
        before do
          @second_frame = Bowling::Frame.new(@first_frame)
          @second_frame.add_shot(6)
          @second_frame.add_shot(4)
        end

        it 'スコアは 37 であること' do
          third_frame = Bowling::Frame.new(@second_frame)
          third_frame.add_shot(0)
          third_frame.add_shot(7)

          frames = [
            @first_frame,
            @second_frame,
            third_frame
          ]

          assert_equal 37, frames.sum(&:score)
        end

        it 'スコアは 42 であること' do
          third_frame = Bowling::Frame.new(@second_frame)
          third_frame.add_shot(3)
          third_frame.add_shot(6)

          frames = [
            @first_frame,
            @second_frame,
            third_frame
          ]

          assert_equal 42, frames.sum(&:score)
        end
      end
    end
  end

  describe '1フレーム目がスペアの場合' do
    describe '2フレーム目がストライクの場合' do
      describe '3フレーム目がオープンフレームの場合' do
        it 'スコアは 36 であること' do
          first_frame = Bowling::Frame.new
          first_frame.add_shot(5)
          first_frame.add_shot(5)

          second_frame = Bowling::Frame.new(first_frame)
          second_frame.add_strike_shot

          third_frame = Bowling::Frame.new(second_frame)
          third_frame.add_shot(2)
          third_frame.add_shot(1)

          frames = [
            first_frame,
            second_frame,
            third_frame
          ]

          assert_equal 36, frames.sum(&:score)
        end
      end
    end

    describe '2フレーム目がスペアの場合' do
      describe '3フレーム目がオープンフレームの場合' do
        it 'スコアは 34 であること' do
          first_frame = Bowling::Frame.new
          first_frame.add_shot(5)
          first_frame.add_shot(5)

          second_frame = Bowling::Frame.new(first_frame)
          second_frame.add_shot(6)
          second_frame.add_shot(4)

          third_frame = Bowling::Frame.new(second_frame)
          third_frame.add_shot(3)
          third_frame.add_shot(2)

          frames = [
            first_frame,
            second_frame,
            third_frame
          ]

          assert_equal 34, frames.sum(&:score)
        end
      end
    end
  end
end
