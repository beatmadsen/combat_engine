# frozen_string_literal: true

module Examples
  # A simple action to demo healing
  class Attack < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    protected

    def on_execute
      @source.start_or_join_battle_with(@target)
      @target.damage(attribute: :hp, amount: 1)
      :successful
    end
  end
end
