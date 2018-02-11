# frozen_string_literal: true

module CombatEngine
  # Main integration point for characters.
  # Should be included in user's character-like class to enable combat features
  module Character
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end

    # Character instance methods defined here
    module InstanceMethods
      def combat_facade
        @_combat_facade ||= Facade.new(
          adapter: combat_adapter,
          state: combat_state
        )
      end

      def update(elapsed_time)
        # TODO: decide on data structure vs object
        combat_state.effect_runner.update(elapsed_time)
      end

      private

      def combat_state
        @_combat_state ||= State.new
      end
    end

    # Character class methods defined here
    module ClassMethods
      def combat_engine_version
        CombatEngine::VERSION
      end
    end
  end
end
