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
      @_damage_controller ||= DamageController.new(self)
    end

    def healing_controller
      @_healing_controller ||= HealingController.new
    end

    def controllers
      @_controllers ||= %i[effects damage healing].map { |prefix| [prefix, send("#{prefix}_controller")] }.to_h.freeze
    end

    def activate_effect(effect_class, source)
      effect = effect_class.new(source.controllers, self.controllers)
      effects_controller.activate(effect)
    end

    def perform(action_class, target)
      action_class.new(self, target).execute
    end

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

    class DamageController
      def initialize(character)
        @character = character
        @filters = []
      end

      def apply_damage(d)
        total_damage = @filters.inject(d) { |acc, filter| filter.modify(acc) }
        @character.hp -= total_damage
      end
    end

    class HealingController

    end
  end

  module EffectState
    class Base
      def initialize(effect, t)
        @effect = effect
        @t = t
      end
    end

    class Init < Base
      def initialize(effect)
        super(effect, 0)
      end

      def advance(𝜹t)
        @effect.after_activate
        Activated.new(@effect, @t)
      end
    end

    class Activated < Base
    end
  end

  class Effect
    def initialize(source_controllers, target_controllers)
      @source_controllers = source_controllers
      @target_controllers = target_controllers
      @state = EffectState::Init.new(self)
    end

    def advance(𝜹t = 0)
      @state = @state.advance(𝜹t)
    end

    def after_activate; raise ImplementationError; end
  end

  class Action
    def initialize(source, target)
      @source = source
      @target = target
    end

    def execute; raise ImplementationError; end
  end
end
