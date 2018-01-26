module CombatEngine
  # Action module contains TODO
  module Action
    # Base should be subclassed to make custom actions
    class MultipleTarget
      def initialize(source:, targets:)
        @source = source
        @targets = targets
      end

      def execute; end
    end
  end
end
