module CombatEngine
  module EffectsRunner
    class Character
      def initialize
        @anytime = Anytime.new
        @battle = Battle.new
        @permanent = Permanent.new
      end

      def add_effect(e)
        runner(e).add_effect(e)
      end

      def remove_effect(e)
        runner(e).remove_effect(e)
      end

      def update(elapsed_time)
        [@anytime, @battle, @permanent, @wearable].each do |r|
          r.update(elapsed_time)
        end
      end

      private

      def runner(e)
        t = e.type
        case t
        when :anytime, :wearable
          @anytime
        when :batle, :permanent
          instance_variable_get("@#{t}")
        end
      end
    end
  end
end
