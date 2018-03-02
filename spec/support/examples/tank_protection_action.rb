# frozen_string_literal: true

module Examples
  # A simple action to demo healing
  class TankProtectionAction < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def adversarial?
      false
    end

    protected

    def on_execute
      @target.receive_effect(
        factory: TankProtectionEffect,
        source: @source
      )
      :successful
    end
  end
end
