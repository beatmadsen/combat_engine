module CombatEngine
  # Effect module contains TODO
  module Effect
    # Base should be subclassed to make custom actions
    class SingleTarget
      def initialize(source:, target:, **options)
        @source = source
        @target = target
        @permanent = options.fetch(:permanent, false)
        @lifetime = options[:lifetime]
      end
    end
  end
end
