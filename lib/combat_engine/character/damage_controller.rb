# frozen_string_literal: true

module CombatEngine
  module Character
    class DamageController
      def initialize(character)
        @character = character
        @filters = []
      end

      def apply_damage(d)
        total_damage = @filters.inject(d) { |acc, filter| filter.modify(acc) }
        @character.hp -= total_damage
      end
    end
  end
end
