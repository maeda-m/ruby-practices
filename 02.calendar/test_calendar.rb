# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'calendar'

describe Calendar do
  it '1970年01月のカレンダーが表示できること' do
    cal = Calendar.new(1970, 1)

    assert_equal '      01月 1970       ', cal.title
    assert_equal '日 月 火 水 木 金 土', cal.header
    assert_equal "             1  2  3 \n" \
                 " 4  5  6  7  8  9 10 \n" \
                 "11 12 13 14 15 16 17 \n" \
                 "18 19 20 21 22 23 24 \n" \
                 '25 26 27 28 29 30 31 ', cal.details
  end

  it '2022年03月のカレンダーが表示できること' do
    cal = Calendar.new(2022, 3)

    assert_equal '      03月 2022       ', cal.title
    assert_equal '日 月 火 水 木 金 土', cal.header
    assert_equal "       1  2  3  4  5 \n" \
                 " 6  7  8  9 10 11 12 \n" \
                 "13 14 15 16 17 18 19 \n" \
                 "20 21 22 23 24 25 26 \n" \
                 '27 28 29 30 31       ', cal.details
  end

  it '2100年12月のカレンダーが表示できること' do
    cal = Calendar.new(2100, 12)

    assert_equal '      12月 2100       ', cal.title
    assert_equal '日 月 火 水 木 金 土', cal.header
    assert_equal "          1  2  3  4 \n" \
                 " 5  6  7  8  9 10 11 \n" \
                 "12 13 14 15 16 17 18 \n" \
                 "19 20 21 22 23 24 25 \n" \
                 '26 27 28 29 30 31    ', cal.details
  end
end
