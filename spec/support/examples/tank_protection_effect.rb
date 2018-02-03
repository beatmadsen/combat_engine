module Examples
  # A tank effect that protects target by sharing damage with tank (source)
  class TankProtectionEffect < CombatEngine::Effect::Base
    LIFETIME = 5000

    def self.create_effect(**options)
      new(**options)
    end

    def initialize(source:, target:, **)
      super(source: source, target: target, lifetime: LIFETIME)
      @run_time = 0
    end

    # Update effect state.
    # Arg is time elapsed since last tick.
    def update(elapsed_time)
      @run_time += elapsed_time
    end

    def active?
      @run_time <= LIFETIME
    end

    def before_damage(**options)
      os = options.slice(:attribute, :amount)
      os[:amount] *= 0.5
      @target.reduce_damage(**os)
      @source.damage(**os)
    end
  end
end
