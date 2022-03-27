# frozen_string_literal: true

require 'date'

module DatePatch
  def beginning_of_week(start_day = :sunday)
    return self if send("#{start_day}?")

    prev_day.beginning_of_week(start_day)
  end

  def end_of_week(start_day = :sunday)
    beginning_of_week(start_day).next_day(6)
  end
end

Date.prepend DatePatch
