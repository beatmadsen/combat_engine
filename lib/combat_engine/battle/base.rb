# frozen_string_literal: true

module CombatEngine
  module Battle
    # Simple class to encapsulate individual battle state
    class Base
      def initialize(participants:)
        @teams = Hash.new { |hash, key| hash[key] = Set.new }
        add_participants(*participants)
        @state = :running
      end

      def participant?(character)
        @teams[character.team].include?(character)
      end

      def add_participants(*characters)
        characters.each { |c| @teams[c.team] << c }
      end

      def update(_elapsed_time)
        return if %i[victory interrupted].include?(@status)
        ws, ls = teams_by_fitness.values_at(true, false)
        end_battle(winning_team: ws.first, losing_teams: ls) if ws.one?
      end

      private

      # If only one team has surving members left, then battle is over
      # That team is the winner
      def teams_by_fitness
        @teams.group_by { |_team, members| members.any?(&:fit_for_battle?) }
              .map { |surviving, pairs| [surviving, pairs.map(&:first)] }
              .to_h
      end

      def end_battle(winning_team:, losing_teams:)
        Battle.end_battle(self)
        @state = :victory
        @teams[winning_team].each(&:after_battle_won)
        losing_teams.flat_map { |t| @teams[t].to_a }
                    .each(&:after_battle_lost)
      end
    end
  end
end
