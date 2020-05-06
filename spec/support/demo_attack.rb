class DemoAttack < CombatEngine::Action
  def execute
    @target.register_effect(DemoInstantDamageEffect, @source)
  end
end
