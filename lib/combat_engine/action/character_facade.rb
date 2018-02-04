# frozen_string_literal: true

module CombatEngine
  module Action
    # Wraps character for use in actions
    class CharacterFacade
      extend Forwardable
      def_delegators :@character,
                     :hp, :team, :battle, :update,
                     :before_action, :after_action,
                     :start_or_join_battle_with, :receive_effect,
                     :accept_action, :fail_incoming_action

      def initialize(character:, damage_machine:, healing_machine:)
        @character = character
        @damage_machine = damage_machine
        @healing_machine = healing_machine
      end

      def heal(attribute:, amount:)
        options = { attribute: attribute, amount: amount }
        @character.before_healing(**options)
        @healing_machine.increase_healing(**options)
        @character.apply_accumulated_healing(attribute: attribute)
        @character.after_healing(**options)
      end

      def damage(attribute:, amount:)
        options = { attribute: attribute, amount: amount }
        @character.before_damage(**options)
        @damage_machine.increase_damage(**options)
        @character.apply_accumulated_damage(attribute: attribute)
        @character.after_damage(**options)
      end

      def last_action_status
        @character.last_executed_action&.status
      end

      def facade(type)
        case type
        when :action then self
        else @character.facade(type)
        end
      end
    end
  end
end
