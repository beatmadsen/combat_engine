# frozen_string_literal: true

module CombatEngine
  # Effect module contains TODO
  module Effect
    # Base should be subclassed to make custom actions
    class Base
      def initialize(source:, target:, **options)
        @source = source
        @target = target
        @permanent = options.fetch(:permanent, false)
        @lifetime = options[:lifetime]
      end

      def before_damage(**options); end

      def after_damage(**options); end

      def before_healing(**options); end

      def after_healing(**options); end

      def before_action(**options); end

      def after_action(**options); end
    end
  end
end
