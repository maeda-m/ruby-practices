# frozen_string_literal: true

require 'forwardable'
require_relative 'transfer'
require_relative 'type/normal_type'
require_relative 'type/strike_type'
require_relative 'type/spare_type'

module Bowling
  module Frame
    class TransferCollection
      extend Forwardable
      delegate reverse_each: :@transfers

      MAX_FRAME_SIZE = 10

      def initialize(values)
        @transfers = []

        current_index = 0
        values.each.with_index do |first_value, value_index|
          transfer = @transfers[current_index]
          transfer ||= create_transfer(first_value, values[value_index.next])
          transfer.add_shot(first_value)
          @transfers[current_index] = transfer

          current_index += 1 if next_frame?
        end
      end

      private

      def create_transfer(first_value, second_value)
        frame_type_class = Frame.registry.find_with_policy(first_value, second_value)
        Transfer.new(frame_type_class)
      end

      def next_frame?
        transfer = @transfers.last

        if final_frame?
          max_shot_size = 3
        else
          return true if transfer.strike_shot?

          max_shot_size = 2
        end

        transfer.finalized?(max_shot_size)
      end

      def final_frame?
        @transfers.size == MAX_FRAME_SIZE
      end
    end
  end
end
