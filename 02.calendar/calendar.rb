# frozen_string_literal: true

require_relative 'date_patch'

class Calendar
  ROW_WIDTH = 21

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
    beginning_of_week = beginning_of_day.beginning_of_week(start_day)
    end_of_week = end_of_day.end_of_week(start_day)

    all_day = (beginning_of_week..end_of_week)
    days_in_month = (beginning_of_day..end_of_day)

    weeks = []
    5.times do |i|
      days_in_week = all_day.to_a.slice(i * 7, 7)
      break if days_in_week.nil?

      weeks << days_in_week.map do |date|
        day = days_in_month.include?(date) ? date.day : nil
        day.to_s.rjust(2)
      end
    end

    weeks.map { |d| d.join(' ').ljust(ROW_WIDTH) }.join("\n")
  end
end
