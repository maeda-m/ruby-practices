# frozen_string_literal: true

require 'date'
require 'debug'

class Calendar
  CELL_WIDTH = 3
  ROW_WIDTH = CELL_WIDTH * 7

  attr_accessor :year, :month, :beginning_of_day, :end_of_day

  def initialize(year, month)
    today = Date.today

    @year = year || today.year
    @month = month || today.month
    Date.new(@year, @month)
  rescue Date::Error
    @year = today.year
    @month = today.month
  ensure
    @beginning_of_day = Date.new(@year, @month, 1)
    @end_of_day = Date.new(@year, @month, -1)
  end

  def show
    puts title
    puts header
    puts details
  end

  def title
    beginning_of_day.strftime('%m月 %Y').center(ROW_WIDTH)
  end

  def header
    %w[日 月 火 水 木 金 土].join(' ')
  end

  def details(start_day = :sunday)
    weeks = []
    days = []

    target_days = (beginning_of_day..end_of_day)
    (beginning_of_week(beginning_of_day, start_day)..end_of_week(end_of_day, start_day)).each_with_index do |date, i|
      if !i.zero? && date.send("#{start_day}?")
        weeks << days
        days = []
      end

      day = target_days.include?(date) ? date.day : nil
      days << day.to_s.rjust(2)
    end
    weeks << days

    weeks.map { |d| d.join(' ').ljust(ROW_WIDTH) }.join("\n")
  end

  def beginning_of_week(date, start_day = :sunday)
    return date if date.send("#{start_day}?")

    beginning_of_week(date.prev_day, start_day)
  end

  def end_of_week(date, start_day = :sunday)
    beginning_of_week(date, start_day).next_day(6)
  end
end
