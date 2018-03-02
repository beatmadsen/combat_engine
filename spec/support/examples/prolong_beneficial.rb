# frozen_string_literal: true

module Examples
  # Xyz
  class ProlongBeneficial < CombatEngine::Action::SingleTarget
    def self.create_action(**options)
      new(**options)
    end

    def adversarial?
      false
    end

    protected

    def on_execute
      friendly_effects = @target.active_effects.reject(&:adversarial?)
      friendly_effects.each { |e| e.remaining_time *= 2 }
      :successful
    end
  end
end
