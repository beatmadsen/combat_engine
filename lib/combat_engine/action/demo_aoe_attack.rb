module CombatEngine
  # Action module contains TODO
  module Action
    # A simple action to demo healing
    class DemoAoeAttack < MultipleTarget
      def execute
        # TODO: this could be done in super class
        @source.start_battle(opponents: @targets)
        @targets.each do |target|
          target.damage_hp(1)
        end
      end
    end
  end
end
