module CombatEngine
  class Controller
    def fire(action_key:, source:, target:)
      klass = lookup_action_class(action_key)
      action = klass.new(source: source, target: target)
      ActionRunner.enqueue(action)
    end

    private

    def lookup_action_class(action_key)
      case action_key
      when :meelee_attack
        Action::MeleeAttack
      else
        Action::Noop
      end
    end
  end

  class ActionRunner
    class << self
      def enqueue(action)
        queue.push(action)
      end

      def update(_elapsed_time)
        while (action = queue.shift)
          action.apply_damage
          action.apply_healing
          action.apply_effect
        end
      end

      private

      def queue
        @_queue ||= []
      end
    end
  end
end
