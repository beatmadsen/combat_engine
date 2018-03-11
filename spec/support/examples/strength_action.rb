# frozen_string_literal: true
module Examples
  # Xyz
  class StrengthAction < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def initialize(**options)
      super
      @duration = options.fetch(:duration)
    end

    protected

    def on_execute
      @source.start_or_join_battle_with(@target)
      @target.receive_effect(
        factory: StrengthEffect,
        source: @source,
        duration: @duration
      )
      :successful
    end
  end
end
