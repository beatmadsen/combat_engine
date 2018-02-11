# frozen_string_literal: true

module CombatEngine
  # Action module contains TODO
  module Action
    # Base should be subclassed to make custom actions
    class SingleTarget < Base
      def initialize(source:, target:)
        super(source: source)
        @target = target
      end

      protected

      def validate
        @target.accept_action?(self) ? :validated : :failed
      end
    end
  end
end
