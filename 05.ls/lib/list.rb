# frozen_string_literal: true

require_relative 'option'
require_relative 'command'

module List
  class NotFoundOrAccessDeniedError < StandardError
  end
end
