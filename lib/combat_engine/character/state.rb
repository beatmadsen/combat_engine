# frozen_string_literal: true

module CombatEngine
  module Character
    # Data structure that holds state for characters
    class State
      attr_reader :action_runner, :effect_runner,
                  :damage_machine, :healing_machine,
                  :action_circuit_breaker

      def initialize
        @action_runner = Action::Runner.new
        @effect_runner = Effect::Runner.new
        @damage_machine = DamageMachine.new
        @healing_machine = HealingMachine.new
        @action_circuit_breaker = Utility::CircuitBreaker.new
      end
    end
  end
end
