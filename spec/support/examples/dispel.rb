# frozen_string_literal: true

module Examples
  # Xyz
  class Dispel < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def initialize(effect:, **)
      super
      @effect = effect
    end

    protected

    def on_execute
      @effect.cancel
      :successful
    end
  end
end
