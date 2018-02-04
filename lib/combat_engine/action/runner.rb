# frozen_string_literal: true

module CombatEngine
  # Action module contains TODO
  module Action
    # Runner schedules and executes actions
    class Runner
      attr_reader :last_executed

      def set(action)
        @next = action
      end

      def clear
        @next = nil
      end

      def execute
        return if @next.nil?
        @next.execute
        @last_executed = @next
        @next = nil
      end
    end
  end
end
