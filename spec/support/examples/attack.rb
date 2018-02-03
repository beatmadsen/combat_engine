module Examples
  # A simple action to demo healing
  class Attack < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def execute
      @source.start_or_join_battle_with(@target)
      @target.damage_attribute(key: :hp, amount: 1)
    end
  end
end
