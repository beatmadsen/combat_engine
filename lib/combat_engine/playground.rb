module CombatEngine
  class Battle
    extend Forwardable

    def_delegators :@state,
                   :participants_locked?,
                   :add_attacker,
                   :add_defender,
                   :add_participant,
                   :enqueue_action

    def initialize
      @state = InitBattleState.new
    end

    def update(elapsed_time)
      @state = @state.advance(elapsed_time)
    end
  end

  class BattleState
    def initialize
      @attackers = Set.new
      @defenders = Set.new
      @actions = []
    end

    def enqueue_action(a)
      @actions.push(a) if a.valid_for_battle?(self)
    end

    def participants_locked?
      true
    end

    def add_participant(p)
      if p.team == attacking_team
        add_attacker(p)
      elsif p.team == defending_team
        add_defender(p)
      else
        raise "Can't add participant. Team not involved"
      end
    end

    def add_attacker(a)
    end

    def add_defender(d)
    end

    def advance(elapsed_time)
    end

    def attacker?(a)
      @attackers.include?(a)
    end

    def defender?(d)
      @defenders.include?(d)
    end
  end

  class InitBattleState < BattleState
    def participants_locked?
      false
    end

    def add_attacker(a)
      # TODO: how do we avoid side-effecting on param?
      a.before_added_to_battle
      a.before_added_as_attacker
      @attackers.push(a)
      @attacking_team = a.team
      a.after_added_as_attacker
      a.after_added_to_battle
    end

    def add_defender(d)
      d.before_added_to_battle
      d.before_added_as_defender
      @defenders.push(d)
      @defending_team = d.team
      d.after_added_as_defender
      d.after_added_to_battle
    end

    def advance(elapsed_time)
      raise 'Bad battle state' if !@attackers.one? || !@defenders.one?
      BeforeBattleState.new.advance(elapsed_time)
    end
  end

  class BeforeBattleState < BattleState
    def participants_locked?
      false
    end

    def add_attacker(a)
      return if @attackers.include?(a) || a.team != @attacking_team
      a.before_added_to_battle
      a.before_added_as_attacker
      @attackers.push(a)
      a.after_added_as_attacker
      a.after_added_to_battle
    end

    def add_defender(d)
      return if @defenders.include?(d) || d.team != @defending_team
      d.before_added_to_battle
      d.before_added_as_defender
      @defenders.push(d)
      d.after_added_as_defender
      d.after_added_to_battle
    end

    def advance(elapsed_time)
    end
  end

  # Responsible for queuing and triggering actions
  class RunningBattleState < BattleState
    def advance(elapsed_time)
    end
  end

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

      @target.reduce_next_damage(amount)
    end
  end
end
