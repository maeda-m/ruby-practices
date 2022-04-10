# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'minitest/autorun'
require_relative '../bowling/frame'
require_relative '../bowling/game'

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

# rubocop:enable Metrics/BlockLength
