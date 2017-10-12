module CombatEngine
  class Battle
    extend Forwardable

    def_delegators :@state,
                   :participants_locked?,
                   :add_attacker,
                   :add_defender,
                   :add_participant,
                   :enqueue_action

    def initialize
      @state = InitBattleState.new
    end

    def update(elapsed_time)
      @state = @state.advance(elapsed_time)
    end
  end
end
