# frozen_string_literal: true

module Examples
  # A simple action to demo healing
  class WardingAction < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    protected

    def on_execute
      @target.receive_effect(
        factory: WardingEffect,
        source: @source
      )
      :successful
    end
  end
end
