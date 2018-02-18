# frozen_string_literal: true

module CombatEngine
  module Battle
    # Battle state entered once a winning team has been found
    class VictoryState
      def initialize(before_ending:, winners:, losers:)
        @before_ending = before_ending
        @winners = winners
        @losers = losers
        @done = false
      end

      def participant?(character); end

      def add_participants(*characters); end

      def advance(_elapsed_time)
        return self if @done
        end_battle
        @done = true
        self
      end

      private

      def end_battle
        @before_ending.call
        @winners.each(&:after_battle_won)
        @losers.each(&:after_battle_lost)
      end
    end
  end
end
