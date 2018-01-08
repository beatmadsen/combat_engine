module CombatEngine
  # Action module contains TODO
  module Action
    # Base should be subclassed to make custom actions
    class Base
      def initialize(source:, target:)
        @source = source
        @target = target
      end

      def execute; end
    end

    # A simple action to demo healing
    class DemoHealAction < Base
      def execute
        @target.heal_hp(1)
      end
    end
  end
end
