# frozen_string_literal: true

module CombatEngine
  # Action module contains TODO
  module Action
    # Base should be subclassed to make custom actions
    class Base
      attr_reader :status

      def initialize(source:, **)
        @source = source
        @status = :waiting
      end

      def execute
        @status = validate
        return unless @status == :validated
        @status = on_execute
      end

      def adversarial?
        true
      end

      protected

      def validate
        :validated
      end

      def on_execute
        :successful
      end
    end
  end
end
