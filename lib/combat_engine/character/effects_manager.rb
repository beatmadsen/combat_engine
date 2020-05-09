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
        # TODO
      end
    end
  end
end
