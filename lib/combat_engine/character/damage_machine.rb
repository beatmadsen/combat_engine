# frozen_string_literal: true

module CombatEngine
  module Character
    # TODO: naming: accumulator?
    # DamageMachine is a state machine that handles
    # damage modification before application
    class DamageMachine
      def initialize
        @deltas = Hash.new { |hash, attribute| hash[attribute] = 0.0 }
        @multipliers = Hash.new { |hash, attribute| hash[attribute] = 1.0 }
      end

      def increase_damage(attribute:, amount:)
        @deltas[attribute] += amount
      end

      def reduce_damage(attribute:, amount:)
        @deltas[attribute] -= amount
      end

      def multiply_damage(attribute:, factor:)
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
