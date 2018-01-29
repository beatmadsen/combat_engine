module CombatEngine
  # Character does bla TODO
  class Character
    attr_reader :hp, :team

    def initialize(team:, hp:)
      @hp = hp
      @action_runner = Action::Runner.new
      @effect_runner = Effect::Runner.new
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

    def add_effect(e)
      @effect_runner.execute(e)
    end

    def update(elapsed_time)
      @action_runner.update(elapsed_time)
      @effect_runner.update(elapsed_time)
    end

    ACTION_FACTORIES = {
      demo_heal:
        lambda do |**options|
          Examples::DemoHeal.new(
            source: options[:source],
            target: options[:target]
          )
        end,
      demo_attack:
        lambda do |**options|
          Examples::DemoAttack.new(
            source: options[:source],
            target: options[:target]
          )
        end,
      demo_aoe_attack:
        lambda do |**options|
          Examples::DemoAoeAttack.new(
            source: options[:source],
            targets: options[:targets]
          )
        end,
      demo_dot_attack:
        lambda do |**options|
          Examples::DemoDotAttack.new(
            source: options[:source],
            target: options[:target]
          )
        end,
    }.freeze

    private

    def create_action(action_name:, **options)
      ACTION_FACTORIES.fetch(action_name)
                      .call(options.merge(source: self))
    end
  end
end
