# frozen_string_literal: true

module CombatEngine
  class Error < StandardError
  end

  class ImplementationError < Error
    def initialize(msg="Method must be implemented")
      super
    end
  end

  module Character
    attr_accessor :hp

    def effects_controller
      raise ImplementationError
    end

    def damage_controller
      raise ImplementationError
    end

    def healing_controller
      raise ImplementationError
    end

    def controllers
      @_controllers ||= %i[effects damage healing].map { |prefix| [prefix, send("#{prefix}_controller") }.to_h.freeze
    end

    def perform(action_class, target)
      action = action_class.new(effects_controller, target.effects_controller)
    end
  end

  module Effect
  end

  module Action
  end
end
