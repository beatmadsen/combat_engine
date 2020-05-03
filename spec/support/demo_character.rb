class DemoCharacter
  include CombatEngine::Character

  def initialize(hp = 0)
    @hp = hp
  end
end
