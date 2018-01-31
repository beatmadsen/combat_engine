module Examples
  # A simple action to demo healing
  class DotAttack < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def execute
      @source.start_or_join_battle_with(@target)
      # TODO: who runs effect - BUG!!!
      @source.fire_effect(factory: DotEffect, target: @target)
    end
  end
end
