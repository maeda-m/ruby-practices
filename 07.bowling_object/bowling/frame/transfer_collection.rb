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

      def initialize(values)
        @transfers = []

        current_index = 0
        values.each.with_index do |first_value, value_index|
          transfer = @transfers[current_index]
          transfer ||= create_transfer(first_value, values[value_index.next])
          transfer.add_shot(first_value)
          @transfers[current_index] = transfer

          current_index += 1 if transfer.next_frame?
        end
      end

      private

      def create_transfer(first_value, second_value)
        frame_type_class = find_with_policy(first_value, second_value)
        position = @transfers.size + 1

        Transfer.new(frame_type_class, position)
      end

      def find_with_policy(first_value, second_value)
        return StrikeType if StrikeType.comply_with?(first_value)
        return SpareType if SpareType.comply_with?(first_value, second_value)

        NormalType
      end
    end
  end
end
