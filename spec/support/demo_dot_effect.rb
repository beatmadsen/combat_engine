module Examples
  # A simple action to demo healing
  class DemoDotEffect < CombatEngine::Effect::SingleTarget
    DAMAGE = 3
    INTERVAL = 1000
    CHARGES = 10

    def initialize(source:, target:)
      super(source: source, target: target, lifetime: CHARGES * INTERVAL)
      @run_time = 0
    end

    # Update effect state.
    # Arg is time elapsed since last tick.
    def update(elapsed_time)
      remaining = (@run_time % INTERVAL) + elapsed_time
      n = remaining / INTERVAL
      n.times { apply_damage }
      @run_time += elapsed_time
    end

    def active?
      # NB: no initial offset, i.e. first charge at t=0
      # e.g. 10th charge at t=9000
      @run_time / INTERVAL < CHARGES
    end

    private

    def apply_damage
      @target.damage_hp(DAMAGE)
    end
  end
end
