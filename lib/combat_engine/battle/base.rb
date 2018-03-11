# frozen_string_literal: true

module CombatEngine
  module Battle
    # Simple class to encapsulate individual battle state
    class Base
      extend Forwardable

      def_delegators :@state, :participant?, :add_participants, :allies

      def initialize(participants:)
        @state = RunningState.new(
          participants: participants,
          before_ending: -> { Battle.end_battle(self) }
        )
      end

      def update(elapsed_time)
        @state = @state.advance(elapsed_time)
      end
    end
  end
end
