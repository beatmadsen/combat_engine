class DemoInstantDamageEffect < CombatEngine::Effect
  def after_activate
    @target_controllers[:damage].apply_damage(10)
  end
end
