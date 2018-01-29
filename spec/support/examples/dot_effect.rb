module Examples
  # A simple effect that applies damage with a regular interval
  class DotEffect < CombatEngine::Effect::SingleTarget
    DAMAGE = 3
    INTERVAL = 1000
    CHARGES = 10

    def initialize(source:, target:)
      super(source: source, target: target, lifetime: CHARGES * INTERVAL)
      @run_time = 0
      @remaining_charges = CHARGES
    end

    # Update effect state.
    # Arg is time elapsed since last tick.
    def update(elapsed_time)
      unused_time = (@run_time % INTERVAL) + elapsed_time
      n1 = unused_time / INTERVAL
      n1 = @remaining_charges if n1 > @remaining_charges
      n1.times { apply_damage }
      @run_time += elapsed_time
      @remaining_charges -= n1
    end

    def active?
      charges_left?
    end

    private

    def charges_left?
      @remaining_charges > 0
    end

    def apply_damage
      @target.damage_hp(DAMAGE)
    end
  end
end
