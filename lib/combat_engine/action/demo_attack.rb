require_relative 'single_target'
module CombatEngine
  # Action module contains TODO
  module Action
    # A simple action to demo healing
    class DemoAttack < SingleTarget
      def execute
        @target.start_or_join_battle(opponents: [@source])
        @target.damage_hp(1)
      end
    end
  end
end