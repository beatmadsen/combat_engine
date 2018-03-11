# frozen_string_literal: true

module Examples
  # A simple action to demo healing
  class AoeAttack < CombatEngine::Action::MultipleTarget
    def self.create_action(**options)
      new(**options)
    end

    protected

    def on_execute
      @source.start_or_join_battle_with(*@targets)
      @targets.each do |target|
        target.damage(attribute: :hp, amount: 1)
      end
      :successful
    end
  end
end
