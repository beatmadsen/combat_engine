module CombatEngine
  # TODO:
  # it would make sense to talk about different kinds of effects
  # depending on where their lifecycle is managed,
  # i.e. which object invokes the effect's callbacks

  # Stages/Modes:
  # 1: Before Battle
  # 1.n: Before player added
  # 1.n: Before player added as attacker/defender
  # 1.n: Add player
  # 1.n: After player added as attacker/defender
  # 1.n: After player added
  #
  # 2: Action substages, repeat for every queued action
  # 2.n: Before action
  # 2.n: Before new effect
  # 2.n: Apply effect
  # 2.n: After new effect
  # 2.n: Before damage
  # 2.n: Apply damage
  # 2.n: After damage
  # 2.n: Before healing
  # 2.n: Apply healing
  # 2.n: After healing
  # 2.n: After action
  #
  # 3: After Battle

  # Effect whose lifecycle is managed by battle state
  class Effect
    def initialize(source:, target:)
      @source = source
      @target = target
    end

    def before_battle(**options)
    end

    def before_participant_added(**options)
    end

    def before_attacker_added(**options)
    end

    def before_defender_added(**options)
    end

    def after_defender_added(**options)
    end

    def after_attacker_added(**options)
    end

    def after_participant_added(**options)
    end

    def after_battle(**options)
    end

    def before_action(**options)
    end

    def before_effect_added(**options)
    end

    def on_effect_added(**options)
    end

    def after_effect_added(**options)
    end

    def before_damage(**options)
    end

    def on_damage(**options)
    end

    def after_damage(**options)
    end

    def before_healing(**options)
    end

    def on_healing(**options)
    end

    def after_healing(**options)
    end

    def after_action(**options)
    end
  end

  # Example: Reduce damage on team members confering some on tank
  # source is tank. One instance for each team member. Target is team member
  class DemoTankEffect < Effect
    def before_damage(**options)
      amount = options[:amount]

      # '_now' suffix indicates bypassing of callbacks
      @source.apply_damage_now(amount)

      # TODO: indicates that player has internal battle damage state machine
      @target.reduce_next_damage(amount)
    end
  end
end
