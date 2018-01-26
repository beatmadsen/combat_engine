module CombatEngine
  # Action module contains TODO
  module Action
    # A simple action to demo healing
    class DemoAttack < Base
      def execute
        @target.start_battle(opponents: [@source])
        @target.damage_hp(1)
      end
    end
  end
end
