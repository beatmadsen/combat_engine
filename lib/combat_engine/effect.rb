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

    def after_activate; raise ImplementationError; end
  end

  module EffectState
    class Base
      def initialize(effect, t)
        @effect = effect
        @t = t
      end
    end

    class Init < Base
      def initialize(effect)
        super(effect, 0)
      end

      def advance(𝜹t)
        @effect.after_activate
        Activated.new(@effect, @t)
      end
    end

    class Activated < Base
    end
  end

end
