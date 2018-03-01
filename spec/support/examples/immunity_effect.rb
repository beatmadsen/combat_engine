# frozen_string_literal: true

module Examples
  # All adversarial actions fail. No source.
  class ImmunityEffect < CombatEngine::Effect::Base
    DURATION = 200

    def self.create_effect(**options)
      new(**options)
    end

    def initialize(target:, **)
      super(target: target, lifetime: DURATION)
    end

    def before_action(**options)
      adversarial = options[:action].adversarial?
      @target.fail_incoming_action if adversarial
    end
  end
end
