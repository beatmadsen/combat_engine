module Examples
  # A simple action to demo healing
  class Attack < CombatEngine::Action::SingleTarget
    def execute
      @source.start_or_join_battle(opponents: [@target])
      @target.damage_hp(1)
    end
  end
end
