module CombatEngine
  module Effect
    # Wraps character for use in effects
    class CharacterFacade
      extend Forwardable
      def_delegators :@character, :hp, :team, :battle
      def_delegators :@damage_machine,
                     :increase_damage, :reduce_damage, :multiply_damage

      def initialize(character:, damage_machine:)
        @character = character
        @damage_machine = damage_machine
      end

      #  TODO: call damage machine with negative damage?
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

      def facade(type)
        case type
        when :effect then self
        else @character.facade(type)
        end
      end
    end
  end
end
