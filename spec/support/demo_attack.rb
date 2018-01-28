module CombatEngine
  # Action module contains TODO
  module Action
    # A simple action to demo healing
    class DemoAttack < SingleTarget
      def execute
        @source.start_or_join_battle(opponents: [@target])
        @target.damage_hp(1)
      end
    end
  end
end
