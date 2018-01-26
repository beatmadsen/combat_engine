module CombatEngine
  # Battle does bla TODO
  class Battle
    # Eigenclass state
    @battles = Set.new

    class << self
      def lookup(character:)
        @battles.find { |b| b.participant?(character) }
      end

      # idempotent: does nothing if mathing battle already exists
      def start(teams:)
        # TODO: write test where this logic doesn't match requirement
        # TODO: refactor!!!
        teams.each do |team|
          team.each do |member|
            return if lookup(character: member)
          end
        end
        @battles << new(teams: teams)
      end
    end

    def initialize(teams: [[], []])
      @teams = teams
    end

    def participant?(character)
      @teams.any? { |team| team.include?(character) }
    end

    def update(elapsed_time); end
  end
end
