# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../bowling'

class BowlingTest < Minitest::Test
  describe 'スペアまたはストライクがある場合' do
    it 'スコアは 107 であること' do
      score = Bowling.play('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
      assert_equal 107, score
    end

    it 'スコアは 134 であること' do
      score = Bowling.play('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
      assert_equal 134, score
    end

    it 'スコアは 144 であること' do
      score = Bowling.play('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
      assert_equal 144, score
    end
  end

  describe '10フレーム目の1投目がストライクだった場合' do
    it 'スコアは 164 であること' do
      score = Bowling.play('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
      assert_equal 164, score
    end
  end

  describe '10フレーム目の2投目がスペアだった場合' do
    it 'スコアは 139 であること' do
      score = Bowling.play('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
      assert_equal 139, score
    end
  end

  describe 'すべてガターの場合' do
    it 'スコアは 0 であること' do
      score = Bowling.play('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
      assert_equal 0, score
    end
  end

  describe 'すべてストライクの場合' do
    it 'スコアは 300 であること' do
      score = Bowling.play('X,X,X,X,X,X,X,X,X,X,X,X')
      assert_equal 300, score
    end
  end
end
