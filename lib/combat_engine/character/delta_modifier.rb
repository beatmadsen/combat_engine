# frozen_string_literal: true

require_relative 'modifier' # TODO: - make this unneccessary
module CombatEngine
  module Character
    # Modifier that records, updates and applies a delta to current value.
    class DeltaModifier < Modifier
      def initialize
        @delta = 0
      end

      def change_by(d)
        @delta += d
      end

      def modify(current_value)
        current_value + @delta
      end

      def type
        :delta_modifier
      end

      def unique?
        true
      end

      # delta must be evaluated last
      def precedence_score
        Modifier::MIN_PRECEDENCE_SCORE - 1
      end
    end
  end
end
