#!/usr/bin/env ruby
# frozen_string_literal: true

class FizzBuzz
  def self.ask(num)
    return '' unless (1..20).to_a.include?(num)

    result = ''
    result += 'Fizz' if (num % 3).zero?
    result += 'Buzz' if (num % 5).zero?

    result = num.to_s if result.empty?

    result
  end
end

if __FILE__ == $PROGRAM_NAME
  1.upto(20) do |i|
    puts FizzBuzz.ask(i)
  end
end
