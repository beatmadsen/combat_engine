module Examples
  # A simple action to demo healing
  class DemoDotAttack < CombatEngine::Action::SingleTarget
    def execute
      @source.start_or_join_battle(opponents: [@target])
      effect = DemoDotEffect.new(source: @source, target: @target)
      @target.add_effect(effect)
    end
  end
end
