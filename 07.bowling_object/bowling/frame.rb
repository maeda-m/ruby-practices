# frozen_string_literal: true

require_relative 'frame_type_registry'
require_relative 'frame/record_value'
require_relative 'frame/transfer'
require_relative 'frame/type'

module Bowling
  module Frame
    MAX_FRAME_SIZE = 10

    def self.build(records)
      values = records.map { |str| RecordValue.new(str) }

      frames = []
      data_transfers(values).reverse_each do |frame_transfer|
        next_frame = frames.first
        frame = frame_transfer.convert(next_frame)

        frames.unshift(frame)
      end

      frames
    end

    def self.registry
      FrameTypeRegistry.instance
    end

    def self.data_transfers(values)
      transfers = []

      current_index = 0
      values.each.with_index do |first_value, value_index|
        second_value = values[value_index.next]
        frame_type_class = registry.find_with_policy(first_value, second_value)

        transfer = transfers[current_index]
        transfer ||= Transfer.new(frame_type_class)
        transfer.add_shot(first_value)
        transfers[current_index] = transfer

        is_final_frame = transfers.size == MAX_FRAME_SIZE
        current_index += 1 if transfer.finalized?(is_final_frame)
      end

      transfers
    end

    private_class_method :data_transfers
  end
end
