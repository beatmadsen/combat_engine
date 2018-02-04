# frozen_string_literal: true

module Examples
  # A simple action to demo healing
  class DotAttack < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    protected

    def on_execute
      @source.start_or_join_battle_with(@target)
      @target.receive_effect(factory: DotEffect, source: @source)
      :successful
    end
  end
end
