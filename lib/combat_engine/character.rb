module CombatEngine
  # Character does bla TODO
  class Character
    attr_reader :hp, :team

    def initialize(team:, hp:)
      @hp = hp
      @action_runner = Action::Runner.new
      @effect_runner = Effect::Runner.new
      @team = team
      @damage_machine = DamageMachine.new
    end

    def fire_action(factory:, **options)
      os = {}
      if t = options[:target]
        os[:target] = t.facade(:action)
      end
      if ts = options[:targets]
        os[:targets] = ts.map { |t| t.facade(:action) }
      end
      os[:source] = facade(:action)
      action = factory.create_action(options.merge(os))
      @action_runner.enqueue(action)
    end

    # TODO
    def heal_attribute(key:, amount:)
      case key
      when :hp then @hp += amount
      end
    end

    def apply_accumulated_damage(attribute:)
      amount = @damage_machine.total(attribute: attribute)
      @damage_machine.reset(attribute)
      case attribute
      when :hp then @hp -= amount
      end
    end

    def start_or_join_battle_with(*participants)
      ps = participants.map { |c| c.facade(:none) }
      ps << self
      Battle.start_or_join(participants: ps)
    end

    def battle
      Battle.lookup(character: self)
    end

    def fire_effect(factory:, **options)
      target = options[:target].facade(:effect)
      source = facade(:effect)
      effect = factory.create_effect(
        options.merge(target: target, source: source)
      )
      @effect_runner.execute(effect)
    end

    def before_damage(**options)
      @effect_runner.before_damage(**options)
    end

    def after_damage(**options)
      @effect_runner.after_damage(**options)
    end

    def update(elapsed_time)
      @action_runner.update(elapsed_time)
      @effect_runner.update(elapsed_time)
    end

    def facade(type)
      case type
      when :none then self
      when :effect
        Effect::CharacterFacade.new(
          character: self,
          damage_machine: @damage_machine
        )
      when :action
        Action::CharacterFacade.new(
          character: self,
          damage_machine: @damage_machine
        )
      end
    end
  end
end
