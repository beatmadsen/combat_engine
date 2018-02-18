# frozen_string_literal: true

module CombatEngine
  module Battle
    # Initial battle state, maintained until either a winner is found or
    # battle interrupted.
    class RunningState
      def initialize(participants:, before_ending:)
        @teams = Hash.new { |hash, key| hash[key] = Set.new }
        add_participants(*participants)
        @before_ending = before_ending
      end

      def participant?(character)
        @teams[character.team].include?(character)
      end

      def add_participants(*characters)
        characters.each { |c| @teams[c.team] << c }
      end

      def advance(elapsed_time)
        ws, ls = teams_by_fitness.values_at(true, false)
        if ws.one?
          VictoryState.new(
            before_ending: @before_ending,
            winners: @teams[ws.first],
            losers: ls.flat_map { |t| @teams[t].to_a }
          ).advance(elapsed_time)
        else
          self
        end
      end

      private

      # If only one team has surving members left, then battle is over
      # That team is the winner
      def teams_by_fitness
        @teams.group_by { |_team, members| members.any?(&:fit_for_battle?) }
              .map { |surviving, pairs| [surviving, pairs.map(&:first)] }
              .to_h
      end
    end
  end
end
