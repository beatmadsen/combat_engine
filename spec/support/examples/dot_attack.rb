module Examples
  # A simple action to demo healing
  class DotAttack < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def execute
      @source.start_or_join_battle_with(@target)
      @target.receive_effect(factory: DotEffect, source: @source)
    end
  end
end
