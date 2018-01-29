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
    end
  end
end
