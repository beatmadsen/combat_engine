# frozen_string_literal: true

module CombatEngine
  # Action module contains TODO
  module Action
    # Base should be subclassed to make custom actions
    class MultipleTarget < Base
      def initialize(source:, targets:)
        super(source: source)
        @targets = targets
      end

      # TODO: test partial failure during validation,
      # i.e. one target fails to accept
    end
  end
end
