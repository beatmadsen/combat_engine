# frozen_string_literal: true

module CombatEngine
  module Character
    class EffectsController
      def initialize(effects_manager)
        @effects_manager = effects_manager
        @filters = []
      end

      def activate(effect)
        # each filter wraps incoming effect in a wrapper that modifies effect behaviour or lifetime
        wrapped_effect = @filters.inject(effect) { |acc, filter| filter.wrap(acc) }
        @effects_manager.activate(wrapped_effect)
      end
    end
  end
end
