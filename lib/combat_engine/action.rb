module CombatEngine
  class Action
    def initialize(source, target)
      @source = source
      @target = target
    end

    def execute; raise ImplementationError; end
  end

end
