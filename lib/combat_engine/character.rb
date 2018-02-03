module CombatEngine
  # Character does bla TODO
  class Character
    extend Forwardable

    attr_reader :hp, :team

    def_delegators :@effect_runner,
                   :before_damage, :after_damage,
                   :before_healing, :after_healing

    def initialize(team:, hp:)
      @hp = hp
      @action_runner = Action::Runner.new
      @effect_runner = Effect::Runner.new
      @team = team
      @damage_machine = DamageMachine.new
      @healing_machine = HealingMachine.new
    end

    def fire_action(factory:, **options)
      os = {}
      if (target = options[:target])
        os[:target] = target.facade(:action)
      end
      if (ts = options[:targets])
        os[:targets] = ts.map { |t| t.facade(:action) }
      end
      os[:source] = facade(:action)
      action = factory.create_action(options.merge(os))
      @action_runner.enqueue(action)
    end

    def apply_accumulated_healing(attribute:)
      amount = @healing_machine.total(attribute: attribute)
      @healing_machine.reset(attribute: attribute)
      case attribute
      when :hp then @hp += amount
      end
    end

    def apply_accumulated_damage(attribute:)
      amount = @damage_machine.total(attribute: attribute)
      @damage_machine.reset(attribute: attribute)
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

    def receive_effect(factory:, **options)
      target = facade(:effect)
      source = options[:source].facade(:effect)
      effect = factory.create_effect(
        options.merge(target: target, source: source)
      )
      @effect_runner.execute(effect)
    end

    def update(elapsed_time)
      @action_runner.update(elapsed_time)
      @effect_runner.update(elapsed_time)
    end

    def facade(type)
      case type
      when :none then self
      when :effect then effect_facade
      when :action then action_facade
      end
    end

    private

    def effect_facade
      Effect::CharacterFacade.new(
        character: self,
        damage_machine: @damage_machine,
        healing_machine: @healing_machine
      )
    end

    def action_facade
      Action::CharacterFacade.new(
        character: self,
        damage_machine: @damage_machine,
        healing_machine: @healing_machine
      )
    end
  end
end
