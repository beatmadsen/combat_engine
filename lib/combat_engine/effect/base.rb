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
    end
  end
end
