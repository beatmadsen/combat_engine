module CombatEngine
  module EffectsRunner
    class Permanent
    end

    # Responsible for executing effects,
    # not keeping track of whether they still apply.
    class Anytime
      def initialize
        @effects = []
      end

      def add_effect(e)
        @effects << e
      end

      def remove_effect(e)
        # TODO
      end

      def update(elapsed_time)
        @effects.each do |e|
          e.update(elapsed_time) do
            # on effect complete
            @effects.remove(e)
          end
        end
      end
    end
  end
end
