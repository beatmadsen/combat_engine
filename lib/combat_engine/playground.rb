module CombatEngine
  module EffectsRunner
    class Character
      def initialize
        @anytime = Anytime.new
        @battle = Battle.new
        @permanent = Permanent.new
        @wearable = Wearable.new
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
        case e.type
        when :anytime
          @anytime
        when :battle
          @battle
        when :permanent
          @permanent
        when :wearable
          @wearable
        end
      end
    end
  end
end
