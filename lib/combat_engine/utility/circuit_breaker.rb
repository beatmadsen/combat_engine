# frozen_string_literal: true

module CombatEngine
  # A module for general purpose classes
  module Utility
    # State machine that can be turned on and off and
    # will execute a block if turned on.
    class CircuitBreaker
      def initialize
        reset
      end

      def reset
        @up = true
      end

      def break
        @up = false
      end

      def try(default_value = nil)
        @up ? yield : default_value
      end
    end
  end
end
