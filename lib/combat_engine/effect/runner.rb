# frozen_string_literal: true

module CombatEngine
  module Effect
    # Runner executes and updates effects while they're active
    class Runner
      def initialize
        @effects = []
      end

      def execute(effect)
        @effects << effect
      end

      def update(elapsed_time)
        @effects.each { |e| e.update(elapsed_time) }
        @effects.keep_if(&:active?)
      end

      def active_effects
        @effects.select(&:active?)
      end

      def before_damage(**options)
        @effects.each { |e| e.before_damage(**options) }
      end

      def after_damage(**options)
        @effects.each { |e| e.after_damage(**options) }
      end

      def before_healing(**options)
        @effects.each { |e| e.before_healing(**options) }
      end

      def after_healing(**options)
        @effects.each { |e| e.after_healing(**options) }
      end

      def before_action(**options)
        @effects.each { |e| e.before_action(**options) }
      end

      def after_action(**options)
        @effects.each { |e| e.after_action(**options) }
      end

      def after_battle_won(**options)
        @effects.each { |e| e.after_battle_won(**options) }
      end

      def after_battle_lost(**options)
        @effects.each { |e| e.after_battle_lost(**options) }
      end
    end
  end
end
