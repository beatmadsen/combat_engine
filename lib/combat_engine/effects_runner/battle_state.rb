require 'set'

module CombatEngine
  module EffectsRunner
    class BattleState
      def initialize(effects: [])
        @effects = effects
        @next_state = self
      end

      def advance(elapsed_time)
        @effects.each do |e|
          e.update(elapsed_time) do
            # on effect complete
            @effects.remove(e)
          end
        end
        @next_state
      end

      def add_effect(_e)
        raise 'Nope'
      end

      def battle_started
        raise 'Nope'
      end

      def battle_ended
        raise 'Nope'
      end

      # TODO: repeat this pattern for all callbacks for all effect runners
      def before_battle(**options)
        # TODO: this pattern is needed so many places. Could extract a class that does the iteration with a specified callback
        @effects.each do |e|
          e.before_battle(options)
        end
      end


      def before_participant_added(**options)
      end

      def before_attacker_added(**options)
      end

      def before_defender_added(**options)
      end

      def after_defender_added(**options)
      end

      def after_attacker_added(**options)
      end

      def after_participant_added(**options)
      end

      def after_battle(**options)
      end

      def before_action(**options)
      end

      def before_effect_added(**options)
      end

      def on_effect_added(**options)
      end

      def after_effect_added(**options)
      end

      def before_damage(**options)
      end

      def on_damage(**options)
      end

      def after_damage(**options)
      end

      def before_healing(**options)
      end

      def on_healing(**options)
      end

      def after_healing(**options)
      end

      def after_action(**options)
      end
    end

    class Inactive < BattleState
      def battle_started
        @next_state = Active.new(@effects)
      end
    end

    class Active < BattleState
      def add_effect(e)
        @effetcs << e
      end

      def battle_ended
        @next_state = Inactive.new(@effetcs)
      end
    end
  end
end
