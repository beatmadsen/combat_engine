module CombatEngine
  # Battle does bla TODO
  class Battle
    # Eigenclass state
    @battles = Set.new

    class << self
      def lookup(character:)
        @battles.find { |b| b.participant?(character) }
      end

      #  idempotent: does nothing if mathing battle already exists
      def start_or_join(teams:)
        # TODO: write test where this logic doesn't match requirement
        battles = teams.flatten.map do |member|
          lookup(character: member)
        end.compact

        if battles.one?
          battles.first.add_participants(**teams)
        elsif battles.empty?
          @battles << new(teams: teams)
        else
          raise 'suggested teams have members in multiple battles'
        end
      end
    end

    def initialize(teams: {})
      @teams = Hash.new { |hash, key| hash[key] = Set.new }
      add_participants(**teams)
    end

    def participant?(character)
      @teams[character.team].include?(character)
    end

    def add_participants(**teams)
      teams.each { |team, members| @teams[team].concat(members) }
    end

    def update(elapsed_time); end
  end
end
