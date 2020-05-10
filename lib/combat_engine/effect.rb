module CombatEngine

  class Effect
    def initialize(source_controllers, target_controllers)
      @source_controllers = source_controllers
      @target_controllers = target_controllers
      @state = EffectState::Init.new(self)
    end

    def advance(𝜹t = 0)
      @state = @state.advance(𝜹t)
    end

    def completed?
      @state.completed?
    end

    def after_activate; raise ImplementationError; end
    
    def t_max; raise ImplementationError; end
  end

  module EffectState
    class Base
      def initialize(effect, t_elapsed)
        @effect = effect
        @t_elapsed = t_elapsed
      end

      def completed?; false; end
    end

    class Init < Base
      def initialize(effect)
        super(effect, 0)
      end

      def advance(𝜹t)
        @effect.after_activate
        if @effect.t_max.zero?
          Completed.new(@effect, 𝜹t)
        else
          Activated.new(@effect, 𝜹t)
        end
      end
    end

    class Completed < Base
      def completed?; true; end
    end

    class Activated < Base
      def advance(𝜹t)
        @t_elapsed += 𝜹t
        if @t_elapsed >= @effect.tmax
          Completed.new(@effect, @t_elapsed)
        else
          self
        end
      end
    end
  end

end
