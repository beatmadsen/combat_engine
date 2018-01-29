module Examples
  # A simple action to demo healing
  class DemoHeal < CombatEngine::Action::SingleTarget
    def execute
      @target.heal_hp(1)
    end
  end
end
