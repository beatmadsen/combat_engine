module CombatEngine
  # Character does bla TODO
  class Character
    attr_reader :hp

    def initialize
      @hp = 100
      @action_runner = Action::Runner.new
    end

    def fire_action(action_name:, target:)
      action = case action_name
               when :demo_heal
                 Action::DemoHealAction.new(source: self, target: target)
               end
      @action_runner.enqueue(action)
    end

    def heal_hp(amount)
      @hp += amount
    end

    def update(elapsed_time)
      @action_runner.update(elapsed_time)
    end
  end
end
