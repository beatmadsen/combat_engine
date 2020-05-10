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
      @_controllers ||= %i[effects damage healing].map do |prefix|
        [prefix, send("#{prefix}_controller")]
      end.to_h.freeze
    end

    def activate_effect(effect_class, source)
      effect = effect_class.new(source.controllers, controllers)
      effects_controller.activate(effect)
    end

    def perform(action_class, target)
      action_class.new(self, target).execute
    end
  end
end
