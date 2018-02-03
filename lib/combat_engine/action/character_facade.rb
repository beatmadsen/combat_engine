module CombatEngine
  module Action
    # Wraps character for use in actions
    class CharacterFacade
      extend Forwardable
      def_delegators :@character,
                     :hp, :team, :battle, :update,
                     :start_or_join_battle_with, :receive_effect

      # TODO: need healing machine with slightly different attributes;
      # reducing damage does nothing below 0 delta;
      # applying negative damage feels unintuitive;
      def heal_attribute(key:, amount:)
        @character.heal_attribute(key: key, amount: amount)
      end

      # TODO: rename to just `damage`
      def damage_attribute(key:, amount:)
        @character.before_damage(attribute: key, amount: amount)
        @damage_machine.increase_damage(attribute: key, amount: amount)
        @character.apply_accumulated_damage(attribute: key)
        @character.after_damage(attribute: key, amount: amount)
      end

      def initialize(character:, damage_machine:)
        @character = character
        @damage_machine = damage_machine
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
