# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'minitest/autorun'
require_relative '../bowling/game'

describe Bowling::Game do
  it 'スコアは 139 であること' do
    game = Bowling::Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game.score
  end

  it 'スコアは 164 であること' do
    game = Bowling::Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 164, game.score
  end

  it 'スコアは 107 であること' do
    game = Bowling::Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 107, game.score
  end

  it 'スコアは 134 であること' do
    game = Bowling::Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 134, game.score
  end

  it 'スコアは 144 であること' do
    game = Bowling::Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
    assert_equal 144, game.score
  end

  it 'スコアは 300 であること' do
    game = Bowling::Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, game.score
  end

  it 'スコアは 0 であること' do
    game = Bowling::Game.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
    assert_equal 0, game.score
  end

  it 'スコアは 144 であること' do
    game = Bowling::Game.new('1,9,2,8,3,7,4,6,5,5,6,4,7,3,8,2,9,1,0,10,0')
    assert_equal 144, game.score
  end
end

# rubocop:enable Metrics/BlockLength
