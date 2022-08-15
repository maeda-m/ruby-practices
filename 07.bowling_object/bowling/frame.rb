# frozen_string_literal: true

require_relative 'frame/record_value'
require_relative 'frame/transfer_collection'

module Bowling
  module Frame
    def self.build(records)
      values = records.map { |str| RecordValue.new(str) }
      transfers = TransferCollection.new(values)

      frames = []
      transfers.reverse_each do |transfer|
        next_frame = frames.first
        frame = transfer.to_frame(next_frame)

        frames.unshift(frame)
      end

      frames
    end
  end
end
