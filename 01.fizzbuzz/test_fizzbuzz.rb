# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'fizzbuzz'

describe FizzBuzz do
  it '1から20までの数をプリントするプログラムであること' do
    assert_equal '1', FizzBuzz.ask(1)
    assert_equal '19', FizzBuzz.ask(19)
  end

  it '3の倍数のときは数の代わりに｢Fizz｣とプリントすること' do
    assert_equal 'Fizz', FizzBuzz.ask(3)
    assert_equal 'Fizz', FizzBuzz.ask(6)
    assert_equal 'Fizz', FizzBuzz.ask(9)
    assert_equal 'Fizz', FizzBuzz.ask(12)
    assert_equal 'Fizz', FizzBuzz.ask(18)
  end

  it '5の倍数のときは｢Buzz｣とプリントすること' do
    assert_equal 'Buzz', FizzBuzz.ask(5)
    assert_equal 'Buzz', FizzBuzz.ask(10)
    assert_equal 'Buzz', FizzBuzz.ask(20)
  end

  it '3と5両方の倍数の場合には｢FizzBuzz｣とプリントすること' do
    assert_equal 'FizzBuzz', FizzBuzz.ask(15)
  end

  it '1から20までの数をプリントするプログラムであること(異常)' do
    assert_equal '', FizzBuzz.ask(0)
    assert_equal '', FizzBuzz.ask(21)
    assert_equal '', FizzBuzz.ask(nil)
    assert_equal '', FizzBuzz.ask('')
    assert_equal '', FizzBuzz.ask(4.2)
  end
end
