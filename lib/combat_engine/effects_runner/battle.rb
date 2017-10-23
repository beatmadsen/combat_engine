module CombatEngine
  module EffectsRunner
    class Battle
      extend Forwardable

      def_delegators :@state,
                     :add_effect,
                     :remove_effect,
                     :battle_started,
                     :battle_ended

      def initialize
        @state = Inactive.new
      end

      def update(elapsed_time)
        @state = @state.advance(elapsed_time)
      end
    end
  end
end
