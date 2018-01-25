module CombatEngine
  # Action module contains TODO
  module Action
    # A simple action to demo healing
    class DemoHealAction < Base
      def execute
        @target.heal_hp(1)
      end
    end
  end
end
