module CombatEngine
  class Action
    def initialize(source:, targets:)
      @source = source
      @targets = targets
    end

    # Override this in case of 'defensive' semantics
    # where source = defender, target = attacker
    # or 'healing' semantics where source team = target team
    #
    # TODO: consider providing this out of the box
    # by initializing action accordingly
    def valid_for_battle?(battle)
      @targets.all? { |t| battle.defender?(t) } &&
        battle.attacker?(@source)
    end

    def apply_damage; end

    def apply_healing; end

    # TODO:
    # some effects might need access to all players in battle
    # like tank effect 'reduce damage on group and transfer damage to self'
    def apply_effect; end
  end

  class ConstantDamageAction < Action
    def initialize(source:, target:, damage:)
      super(source: source, target: target)
      @damage = damage
    end

    def apply_damage
      @target.apply_damage(@damage)
    end
  end

  class ApplyDemoTankEffectAction < Action
    def apply_effect
      # TODO: find a cleaner way for this.
      @target.apply_effect(DemoTankEffect.new(source: @source, target: @target))
    end
  end
end
