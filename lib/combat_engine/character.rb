module CombatEngine
  # Character does bla TODO
  class Character
    attr_reader :hp

    def initialize
      @hp = 100
      @action_runner = Action::Runner.new
    end

    def fire_action(action_name:, **options)
      action = case action_name
               when :demo_heal
                 Action::DemoHeal.new(source: self, target: options[:target])
               when :demo_attack
                 Action::DemoAttack.new(source: self, target: options[:target])
               when :demo_aoe_attack
                 Action::DemoAoeAttack.new(source: self, targets: options[:targets])
               end
      @action_runner.enqueue(action)
    end

    def heal_hp(amount)
      @hp += amount
    end

    def damage_hp(amount)
      @hp -= amount
    end

    def start_or_join_battle(opponents: [])
      Battle.start_or_join(teams: [[self], opponents])
    end

    def battle
      Battle.lookup(character: self)
    end

    def update(elapsed_time)
      @action_runner.update(elapsed_time)
    end
  end
end
