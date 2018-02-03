module Examples
  # A simple action to demo healing
  class Heal < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def execute
      @target.heal(attribute: :hp, amount: 1)
    end
  end
end
