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
    end
  end
end
