# frozen_string_literal: true

require 'date'

class Calendar
  ROW_WIDTH = 21

  attr_accessor :beginning_of_month, :end_of_month

  def initialize(year, month)
    today = Date.today

    year ||= today.year
    month ||= today.month

    Date.new(year, month)
  rescue Date::Error
    year = today.year
    month = today.month
  ensure
    @beginning_of_month = Date.new(year, month, 1)
    @end_of_month = Date.new(year, month, -1)
  end

  def show
    puts title
    puts header
    puts dates
  end

  def title
    beginning_of_month.strftime('%m月 %Y').center(ROW_WIDTH)
  end

  def header
    %w[日 月 火 水 木 金 土].join(' ')
  end

  def dates
    days_in_month = (beginning_of_month..end_of_month)

    result = '   ' * beginning_of_month.wday
    days_in_month.each do |date|
      result += date.day.to_s.rjust(2)
      result +=  ' '
      result +=  "\n" if date.saturday? && end_of_month != date
    end

    result
  end
end
