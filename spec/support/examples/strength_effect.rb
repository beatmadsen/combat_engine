# frozen_string_literal: true

module Examples
  # All adversarial effects fail. No source.
  class StrengthEffect < CombatEngine::Effect::Base
    FACTOR = 0.9

    def self.create_effect(**options)
      new(**options)
    end

    def initialize(source:, target:, duration:, **)
      super(source: source, target: target, lifetime: duration)
    end

    def on_completion
      @target.remove_modifier(attribute: :strength, modifier: modifier)
    end

    def after_init
      @target.add_modifier(attribute: :strength, modifier: modifier)
    end

    class StrengthModifier < CombatEngine::Character::Modifier
      def modify(current_value)
        current_value * FACTOR
      end

      def type
        :strength_modifier
      end
    end

    private

    def modifier
      @_modifier ||= StrengthModifier.new
    end
  end
end
