# frozen_string_literal: true

module CombatEngine
  module Character
    # Facade wraps character state and adapter to provide an interface
    # for common combat interactions.
    class Facade
      extend Forwardable

      def_delegators :@adapter,
                     :fit_for_battle?, :attribute, :team

      def_delegators :@state,
                     :effect_runner, :action_runner,
                     :damage_machine, :healing_machine,
                     :action_circuit_breaker

      def_delegators :damage_machine,
                     :increase_damage, :reduce_damage, :multiply_damage

      def_delegators :healing_machine,
                     :increase_healing, :reduce_healing, :multiply_healing

      def_delegators :effect_runner,
                     :before_damage, :after_damage,
                     :before_action, # see after_action below
                     :before_healing, :after_healing

      private :effect_runner, :action_runner,
              :damage_machine, :healing_machine,
              :action_circuit_breaker

      def initialize(adapter:, state:)
        @adapter = adapter
        @state = state
      end

      def after_action(**options)
        action_circuit_breaker.reset
        effect_runner.after_action(**options)
      end

      def battle
        Battle.lookup(character: self)
      end

      def damage(attribute:, amount:)
        options = { attribute: attribute, amount: amount }
        before_damage(**options)
        increase_damage(**options)
        apply_accumulated_damage(attribute: attribute)
        after_damage(**options)
      end

      def heal(attribute:, amount:)
        options = { attribute: attribute, amount: amount }
        before_healing(**options)
        increase_healing(**options)
        apply_accumulated_healing(attribute: attribute)
        after_healing(**options)
      end

      def fire_action(factory:, **options)
        os = options.slice(:target, :targets).merge!(source: self)
        action = factory.create_action(os)
        action_runner.set(action)
        cs = os.values.flatten
        cs.each { |c| c.before_action(action: action) }
        action_runner.execute
        cs.each { |c| c.after_action(action: action) }
      end

      def accept_action?(_a)
        action_circuit_breaker.try(false) { true }
      end

      def start_or_join_battle_with(*participants)
        Battle.start_or_join(participants: participants + [self])
      end

      def receive_effect(factory:, **options)
        os = options.merge(target: self)
        effect = factory.create_effect(os)
        effect_runner.execute(effect)
      end

      def last_action_status
        action_runner.last_executed&.status
      end

      def fail_incoming_action
        action_circuit_breaker.break
      end

      private

      def apply_accumulated_healing(attribute:)
        amount = healing_machine.total(attribute: attribute)
        healing_machine.reset(attribute: attribute)
        @adapter.modify(attribute: attribute, delta: amount)
      end

      def apply_accumulated_damage(attribute:)
        amount = damage_machine.total(attribute: attribute)
        damage_machine.reset(attribute: attribute)
        @adapter.modify(attribute: attribute, delta: -amount)
      end
    end
  end
end
