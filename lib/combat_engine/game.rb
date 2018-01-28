module CombatEngine
  # The main integration point with a game
  class Game
    @characters = Set.new
    class << self
      def add_characters(*c)
        @characters.merge(*c)
      end

      def update(elapsed_time)
        Battle.update(elapsed_time)
        @characters.each { |c| c.update(elapsed_time) }
      end
    end
  end
end
