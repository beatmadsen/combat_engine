module CombatEngine
  # Character does bla TODO
  class Character
    attr_reader :hp, :team

    def initialize(team:)
      @hp = 100
      @action_runner = Action::Runner.new
      @team = team
    end

    def fire_action(action_name:, **options)
      action = create_action(action_name: action_name, **options)
      @action_runner.enqueue(action)
    end

    def heal_hp(amount)
      @hp += amount
    end

    def damage_hp(amount)
      @hp -= amount
    end

    def start_or_join_battle(opponents: [])
      Battle.start_or_join(participants: [self] + opponents)
    end

    def battle
      Battle.lookup(character: self)
    end

    def update(elapsed_time)
      @action_runner.update(elapsed_time)
    end

    ACTION_FACTORIES = {
      demo_heal:
        lambda do |**options|
          Action::DemoHeal.new(
            source: options[:source],
            target: options[:target]
          )
        end,
      demo_attack:
        lambda do |**options|
          Action::DemoAttack.new(
            source: options[:source],
            target: options[:target]
          )
        end,
      demo_aoe_attack:
        lambda do |**options|
          Action::DemoAoeAttack.new(
            source: options[:source],
            targets: options[:targets]
          )
        end
    }.freeze

    private

    def create_action(action_name:, **options)
      ACTION_FACTORIES[action_name].call(options.merge(source: self))
    end
  end
end
