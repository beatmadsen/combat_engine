module Examples
  # A simple action to demo healing
  class DemoAoeAttack < CombatEngine::Action::MultipleTarget
    def execute
      @source.start_or_join_battle(opponents: @targets)
      @targets.each { |target| target.damage_hp(1) }
    end
  end
end
