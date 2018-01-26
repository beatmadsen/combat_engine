module CombatEngine
  # Character does bla TODO
  class Character
    attr_reader :hp, :battle

    def initialize
      @hp = 100
      @action_runner = Action::Runner.new
    end

    def fire_action(action_name:, target:)
      action = case action_name
               when :demo_heal
                 Action::DemoHeal.new(source: self, target: target)
               when :demo_attack
                 Action::DemoAttack.new(source: self, target: target)
               end
      @action_runner.enqueue(action)
    end

    def heal_hp(amount)
      @hp += amount
    end

    def damage_hp(amount)
      @hp -= amount
    end

    def start_battle(opponents: [])
      @battle = Battle.new(teams: [[self], opponents])
    end

    def update(elapsed_time)
      @action_runner.update(elapsed_time)
    end
  end
end
