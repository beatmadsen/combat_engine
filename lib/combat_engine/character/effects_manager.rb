# frozen_string_literal: true

module CombatEngine
  module Character
    class EffectsManager
      def initialize
        @effects = []
      end

      def activate(effect)
        @effects << effect
        effect.advance
      end

      def advance_effects(𝜹t)
        @effects.each { |e| e.advance(𝜹t) }
        @effects.reject!(&:completed?)
      end
    end
  end
end
