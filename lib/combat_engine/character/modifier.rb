# frozen_string_literal: true

module CombatEngine
  module Character
    # Base class for attribute modifiers.
    # A modifier can be applied to an attribute and will be evaluated along
    # with other modifiers when calculating current value of attribute.
    # Evaluation order depends on precence scores of modifiers.
    class Modifier
      MAX_PRECEDENCE_SCORE = 10_000
      MIN_PRECEDENCE_SCORE = 0

      def modify(current_value)
        current_value
      end

      def type
        :no_op_modifier
      end

      # The higher the number, the higher the precedence;
      # Modifier with the highest precedence gets evaluated first.
      def precedence_score
        100
      end

      # Can two or more modifiers of this type be allowed
      #  to be active at the same time
      def unique?
        false
      end

      # Identifier for this particular instance
      def unique_key
        @_unique_key ||=
          "#{type} | #{precedence_score} | #{SecureRandom.rand(10_000)}".to_sym
      end
    end
  end
end
