# frozen_string_literal: true

module CombatEngine

  module Character
    attr_accessor :hp

    def effects_manager
      @_effects_manager ||= EffectsManager.new
    end

    def effects_controller
      @_effects_controller ||= EffectsController.new(effects_manager)
    end

    def damage_controller
      @_damage_controller ||= DamageController.new
    end

    def healing_controller
      @_healing_controller ||= HealingController.new
    end

    def controllers
      @_controllers ||= %i[effects damage healing].map { |prefix| [prefix, send("#{prefix}_controller")] }.to_h.freeze
    end

    def register_effect(effect_class, source)
      effect = effect_class.new(source.controllers, self.controllers)
      effects_controller.register(effect)
    end

    def perform(action_class, target)
      action_class.new(self, target).execute
    end

    class EffectsController
      def initialize(effects_manager)
        @effects_manager = effects_manager
        @filters = []
      end

      def register(effect)
        # each filter wraps incoming effect in a wrapper that modifies effect behaviour or lifetime
        wrapped_effect = @filters.inject(effect) { |acc, filter| filter.wrap(acc) }
        @effects_manager.register(wrapped_effect)
      end
    end

    class EffectsManager
      def initialize
        @effects = []
      end

      def register(effect)
        @effects << effect
      end

      def advance_effects(dt)
        # TODO
      end
    end

    class DamageController

    end

    class HealingController

    end
  end

  class Effect
    def initialize(source_controllers, target_controllers)
      @source_controllers = source_controllers
      @target_controllers = target_controllers
    end
  end

  class Action
    def initialize(source, target)
      @source = source
      @target = target
    end

    def execute; raise ImplementationError; end
  end
end
