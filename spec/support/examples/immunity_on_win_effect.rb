# frozen_string_literal: true

module Examples
  # Triggers an immunity effect when target wins a battle
  class ImmunityOnWinEffect < CombatEngine::Effect::Base
    def self.create_effect(**options)
      new(**options)
    end

    def initialize(target:, **)
      super(target: target, permanent: true)
    end

    def after_battle_won(**_options)
      @target.receive_effect(factory: ImmunityEffect)
    end
  end
end
