# frozen_string_literal: true

module Examples
  # A simple action to demo healing
  class Heal < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def adversarial?
      false
    end

    protected

    def on_execute
      @target.heal(attribute: :hp, amount: 1)
      :successful
    end
  end
end
