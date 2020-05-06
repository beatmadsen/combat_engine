
# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup # ready!


require 'securerandom'

# CombatEngine does bla TODO
module CombatEngine
  class Error < StandardError
  end

  class ImplementationError < Error
    def initialize(msg="Method must be implemented")
      super
    end
  end
end
