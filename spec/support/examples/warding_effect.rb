# frozen_string_literal: true

module Examples
  # A tank effect that protects target by sharing damage with tank (source)
  class WardingEffect < CombatEngine::Effect::Base
    LIFETIME = 200

    def self.create_effect(**options)
      new(**options)
    end

    def initialize(source:, target:, **)
      super(source: source, target: target, lifetime: LIFETIME)
      @run_time = 0
    end

    def before_action(**options)
      adversarial = options[:action].adversarial?
      @target.fail_incoming_action if adversarial
    end

    # Update effect state.
    # Arg is time elapsed since last tick.
    def update(elapsed_time)
      @run_time += elapsed_time
    end

    def active?
      @run_time <= LIFETIME
    end
  end
end
