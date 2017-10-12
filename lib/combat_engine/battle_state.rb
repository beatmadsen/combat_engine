module CombatEngine
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
end
