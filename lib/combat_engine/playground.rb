module CombatEngine
  class Controller
    def fire(action_key:, source:, targets:)
      klass = lookup_action_class(action_key)

      # Look up all battles by source and targets.
      # If more than one unique is found, then stop.
      return if Battle::Service.conflict?(targets + [source])

      battle = Battle::Service.find_or_create(source: source, targets: targets)
      action = klass.new(source: source, targets: targets)

      # TODO: wouldn't this already be taken into account above?
      return unless action.valid_for_battle?(battle)
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
