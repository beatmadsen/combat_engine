# frozen_string_literal: true

module CombatEngine
  # Effect module contains TODO
  module Effect
    # Base should be subclassed to make custom actions
    class Base
      class NoSource
      end

      def initialize(target:, **options)
        @source = options.fetch(:source, NoSource)
        @target = target
        @permanent = options.fetch(:permanent, false)
        @lifetime = options[:lifetime]
        @run_time = 0
      end

      def before_damage(**options); end

      def after_damage(**options); end

      def before_healing(**options); end

      def after_healing(**options); end

      def before_action(**options); end

      def after_action(**options); end

      def after_battle_won(**options); end

      def after_battle_lost(**options); end

      def active?
        @permanent || (@run_time <= @lifetime)
      end

      # Update effect state.
      # Arg is time elapsed since last tick.
      def update(elapsed_time)
        @run_time += elapsed_time
      end
    end
  end
end
