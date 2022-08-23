# frozen_string_literal: true

require_relative 'frame/record_value'
require_relative 'frame/transfer'
require_relative 'frame/type/strike_type'
require_relative 'frame/type/spare_type'
require_relative 'frame/type/normal_type'

module Bowling
  module Frame
    MAX_HIT_COUNT = 10

    def self.build(records)
      values = records.map { |str| RecordValue.new(str) }
      transfers = create_transfers(values)

      frames = []
      transfers.reverse_each do |transfer|
        next_frame = frames.first
        frame = transfer.to_frame(next_frame)

        frames.unshift(frame)
      end

      frames
    end

    def self.create_transfers(values)
      transfers = []

      current_index = 0
      values.each.with_index do |first_value, value_index|
        if transfers[current_index].nil?
          second_value = values[value_index.next]
          frame_type_class = find_frame_type_class(first_value, second_value)

          position = transfers.size + 1
          transfer = Transfer.new(frame_type_class, position)
        else
          transfer = transfers[current_index]
        end

        transfer.add_shot(first_value)
        transfers[current_index] = transfer

        current_index += 1 if transfer.next_frame?
      end

      transfers
    end

    def self.find_frame_type_class(first_value, second_value)
      return StrikeType if first_value.strike?
      return SpareType if first_value + second_value == MAX_HIT_COUNT

      NormalType
    end

    private_class_method :create_transfers, :find_frame_type_class
  end
end
