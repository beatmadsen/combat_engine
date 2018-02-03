module CombatEngine
  module Effect
    # Wraps character for use in effects
    class CharacterFacade
      extend Forwardable
      def_delegators :@character, :hp, :team, :battle
      def_delegators :@damage_machine,
                     :increase_damage, :reduce_damage, :multiply_damage

      def initialize(character:, damage_machine:, healing_machine:)
        @character = character
        @damage_machine = damage_machine
        @healing_machine = healing_machine
      end

      def heal(attribute:, amount:)
        @character.before_healing(attribute: attribute, amount: amount)
        @healing_machine.increase_healing(attribute: attribute, amount: amount)
        @character.apply_accumulated_healing(attribute: attribute)
        @character.after_healing(attribute: attribute, amount: amount)
      end

      def damage(attribute:, amount:)
        @character.before_damage(attribute: attribute, amount: amount)
        @damage_machine.increase_damage(attribute: attribute, amount: amount)
        @character.apply_accumulated_damage(attribute: attribute)
        @character.after_damage(attribute: attribute, amount: amount)
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
