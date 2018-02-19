
# frozen_string_literal: true

module CombatEngine
  module Character
    # Encapsulation of character attributes that can be modified over time
    class Attribute
      def initialize(adapter:, name:)
        @name = name
        @adapter = adapter
        @modifiers = Hash.new { |hash, key| hash[key] = [] }
      end

      def current_value
        @adapter.current_value(attribute: @name)
      end

      # Adds argument to current value and reflects it in underlying character
      # TODO: bounds checking (?) - maybe better done in adapter
      def change_by(d)
        within_value_refresh { change_delta_by(d) }
      end

      def add_modifier(m)
        within_value_refresh do
          append_modifier(m)
        end
      end

      def remove_modifier(type:, unique_key:)
        within_value_refresh do
          @modifiers[type].delete_if { |m| m.unique_key == unique_key }
        end
      end

      private

      def append_modifier(m)
        if m.unique?
          @modifiers[m.type] = [m].freeze
        else
          @modifiers[m.type] << m
        end
      end

      def within_value_refresh
        adjust_delta
        yield
        save_modified_value
      end

      def save_modified_value
        update_adapter(recalculate_value)
      end

      def change_delta_by(d)
        delta_modifier.change_by(d)
      end

      # Capture outside changes to current value
      # and store them in delta modifier
      def adjust_delta
        diff = current_value - recalculate_value
        change_delta_by(diff)
      end

      def delta_modifier
        @_delta_modifier ||=
          DeltaModifier.new.tap { |m| append_modifier(m) }
      end

      def recalculate_value
        modifiers_sorted_by_precedence.inject(base_value) do |acc, m|
          m.modify(acc)
        end
      end

      def modifiers_sorted_by_precedence
        @modifiers.values.flatten.sort_by!(&:precedence_score).reverse!
      end

      def update_adapter(value)
        @adapter.update(attribute: @name, value: value)
      end

      def base_value
        @adapter.base_value(attribute: @name)
      end
    end
  end
end
