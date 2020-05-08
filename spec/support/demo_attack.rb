class DemoAttack < CombatEngine::Action
  def execute
    @target.activate_effect(DemoInstantDamageEffect, @source)
  end
end
