# frozen_string_literal: true

module CombatEngine
  module Character
    attr_accessor :hp, :effects_controller

    def perform(action_class, target)
      action = action_class.new(effects_controller, target.effects_controller)
    end
  end

  module Effect
  end

  module Action
  end
end
