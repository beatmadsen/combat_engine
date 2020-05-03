class DemoAttack
  include CombatEngine::Action

  def initialize(source, target)
    @source = source
    @target = target
  end
end
