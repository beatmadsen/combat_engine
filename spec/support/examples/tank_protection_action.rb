module Examples
  # A simple action to demo healing
  class TankProtectionAction < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def execute
      @source.fire_effect(
        factory: TankProtectionEffect,
        target: @target
      )
    end
  end
end
