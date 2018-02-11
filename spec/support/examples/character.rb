# frozen_string_literal: true

module Examples
  # A simple user character
  class Character
    include CombatEngine::Character

    attr_reader :team
    attr_accessor :hp

    class CombatAdapter
      extend Forwardable

      def_delegators :@character, :team

      def initialize(character)
        @character = character
      end

      def attribute(a)
        return unless a == :hp
        @character.hp
      end

      def modify(attribute:, delta:)
        return unless attribute == :hp
        @character.hp += delta
      end

      def fit_for_battle?
        @character.hp > 0
      end
    end

    def initialize(team:, hp:)
      @team = team
      @hp = hp
    end

    def combat_adapter
      @_combat_adapter ||= CombatAdapter.new(self)
    end
  end
end
