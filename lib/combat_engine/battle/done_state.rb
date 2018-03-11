# frozen_string_literal: true

module CombatEngine
  module Battle
    # Battle state entered once a winning team has been found
    class DoneState
      def participant?(character); end

      def add_participants(*characters); end

      def allies
        []
      end

      def advance(_elapsed_time)
        self
      end
    end
  end
end
