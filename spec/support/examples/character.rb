# frozen_string_literal: true
module Examples
  # A simple user character
  class Character
    include CombatEngine::Character

    attr_reader :team
    attr_accessor :hp, :base_hp, :strength, :base_strength

    class CombatAdapter
      extend Forwardable

      def_delegators :@character, :team

      def initialize(character)
        @character = character
      end

      # TODO
      def attribute(a)
        current_value(attribute: a)
      end

      def current_value(attribute:)
        case attribute
        when :hp, :strength
          @character.send(attribute)
        end
      end

      def base_value(attribute:)
        case attribute
        when :hp, :strength
          a = ['base_', attribute].join
          @character.send(a)
        end
      end

      def update(attribute:, value:)
        case attribute
        when :hp then @character.hp = value
        when :strength then @character.strength = value
        end
      end

      def fit_for_battle?
        @character.hp > 0
      end
    end

    def initialize(team:, hp:, strength: 100)
      @team = team
      @hp = @base_hp = hp
      @strength = @base_strength = strength
    end

    def combat_adapter
      @_combat_adapter ||= CombatAdapter.new(self)
    end
  end
end
