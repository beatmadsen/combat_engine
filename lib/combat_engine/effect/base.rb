# frozen_string_literal: true

module CombatEngine
  # Effect module contains effect implementations and supporting classes
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
        @running = true
        after_init
      end

      def after_init; end

      def on_completion; end

      def before_damage(**options); end

      def after_damage(**options); end

      def before_healing(**options); end

      def after_healing(**options); end

      def before_action(**options); end

      def after_action(**options); end

      def after_battle_won(**options); end

      def after_battle_lost(**options); end

      def cancel
        complete if @running && !@permanent
      end

      def active?
        @running && (@permanent || @run_time <= @lifetime)
      end

      def adversarial?
        true
      end

      def remaining_time=(addend)
        return if @permanent
        @lifetime = @run_time + addend
      end

      def remaining_time
        return if @permanent
        @lifetime - @run_time
      end

      # Update effect state.
      # Arg is time elapsed since last tick.
      def update(elapsed_time)
        @run_time += elapsed_time
        complete unless active?
      end

      private

      def complete
        @running = false
        on_completion
      end
    end
  end
end
