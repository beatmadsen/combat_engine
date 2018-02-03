module Examples
  # A simple action to demo healing
  class TankProtectionAction < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def execute
      @target.receive_effect(
        factory: TankProtectionEffect,
        source: @source
      )
    end
  end
end
