module CombatEngine
  # Action module contains TODO
  module Action
    # Runner schedules and executes actions
    class Runner
      def enqueue(action)
        queue.push(action)
      end

      def update(_elapsed_time)
        while (action = queue.shift)
          action.execute
        end
      end

      private

      def queue
        @_queue ||= []
      end
    end
  end
end
