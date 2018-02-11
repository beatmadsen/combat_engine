# frozen_string_literal: true

module CombatEngine
  module Battle
    # Simple class to encapsulate individual battle state
    class Base
      def initialize(participants:)
        @teams = Hash.new { |hash, key| hash[key] = Set.new }
        add_participants(*participants)
      end

      def participant?(character)
        @teams[character.team].include?(character)
      end

      def add_participants(*characters)
        characters.each { |c| @teams[c.team] << c }
      end

      def update(_elapsed_time)
        @teams.each_value do |members|
          unless members.any?(&:fit_for_battle?)
            Battle.end_battle(self)
            break
          end
        end
      end
    end
  end
end
