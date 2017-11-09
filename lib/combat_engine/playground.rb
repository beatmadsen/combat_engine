module CombatEngine
  class Controller
    def fire(action_key:, source:, target:)
      klass = lookup_action_class(action_key)
      action = klass.new(source: source, target: target)
      Service.fire_action(action)
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

  class Service
    # TODO - schedule it
    def self.fire_action(action)
    end
  end
end
