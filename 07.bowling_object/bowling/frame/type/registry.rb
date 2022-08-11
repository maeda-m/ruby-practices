# frozen_string_literal: true

require 'singleton'

module Bowling
  module Frame
    class Registry
      include Singleton

      def initialize
        @frame_type_classes = []
      end

      def register_type(frame_type_class)
        @frame_type_classes << frame_type_class
      end

      def find_with_policy(first_value, second_value)
        @frame_type_classes.find do |frame_type_class|
          frame_type_class.comply_with?(first_value, second_value)
        end
      end
    end
  end
end
