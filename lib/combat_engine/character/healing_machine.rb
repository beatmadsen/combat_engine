# frozen_string_literal: true

module CombatEngine
  module Character
    # HealingMachine is a state machine that handles
    # healing modification before application
    class HealingMachine
      def initialize
        @deltas = Hash.new { |hash, attribute| hash[attribute] = 0.0 }
        @multipliers = Hash.new { |hash, attribute| hash[attribute] = 1.0 }
      end

      def increase_healing(attribute:, amount:)
        @deltas[attribute] += amount
      end

      def reduce_healing(attribute:, amount:)
        @deltas[attribute] -= amount
      end

      def multiply_healing(attribute:, factor:)
        @multipliers[attribute] *= factor
      end

      def total(attribute:)
        delta = @deltas[attribute]
        delta <= 0.0 ? 0.0 : delta * @multipliers[attribute]
      end

      def reset(attribute:)
        @deltas.delete(attribute)
        @multipliers.delete(attribute)
      end
    end
  end
end
