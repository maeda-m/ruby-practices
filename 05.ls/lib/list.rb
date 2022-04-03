# frozen_string_literal: true

module List
  MAX_COLUMN_COUNT = 3

  class NotFoundOrAccessDeniedError < StandardError
  end
end

require_relative 'option'
require_relative 'command'
