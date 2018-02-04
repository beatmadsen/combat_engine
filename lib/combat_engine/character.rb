# frozen_string_literal: true

module CombatEngine
  # Character does bla TODO
  class Character
    extend Forwardable

    attr_reader :hp, :team

    def_delegators :@effect_runner,
                   :before_damage, :after_damage,
                   :before_action,
                   :before_healing, :after_healing

    def initialize(team:, hp:)
      @hp = hp
      @action_runner = Action::Runner.new
      @effect_runner = Effect::Runner.new
      @team = team
      @damage_machine = DamageMachine.new
      @healing_machine = HealingMachine.new
      @accept_incoming_action = true
    end

    def fire_action(factory:, **options)
      os = participant_facades(options)
      action = factory.create_action(options.merge(os))
      cs = os.values.flatten
      @action_runner.set(action)
      cs.each { |c| c.before_action(action: action) }
      @action_runner.execute
      cs.each { |c| c.after_action(action: action) }
    end

    def fail_incoming_action
      @accept_incoming_action = false
    end

    def accept_action(_a)
      @accept_incoming_action
    end

    def after_action(**options)
      @accept_incoming_action = true
      @effect_runner.after_action(**options)
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

    def last_executed_action
      @action_runner.last_executed
    end

    def update(elapsed_time)
      @effect_runner.update(elapsed_time)
    end

    def facade(type)
      facades[type] ||=
        case type
        when :none then self
        when :effect then effect_facade
        when :action then action_facade
        end
    end

    private

    def participant_facades(options)
      os = {}
      os[:target] = options[:target]&.facade(:action)
      os[:targets] = options[:targets]&.map { |t| t.facade(:action) }
      os[:source] = facade(:action)
      os.compact!
      os
    end

    def facades
      @_facades ||= {}
    end

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
