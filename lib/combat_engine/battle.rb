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
      def start_or_join(participants:)
        # TODO: write test where this logic doesn't match requirement
        active_battles = participants.map { |c| lookup(character: c) }.compact
        if active_battles.one?
          active_battles.first.add_participants(*participants)
        elsif active_battles.empty?
          @battles << new(participants: participants)
        else
          raise 'suggested teams have members in multiple battles'
        end
      end
    end

    def initialize(participants:)
      @teams = Hash.new { |hash, key| hash[key] = Set.new }
      add_participants(*participants)
    end

    def participant?(character)
      @teams[character.team].include?(character)
    end

    def add_participants(*characters)
      characters.each { |ch| @teams[ch.team] << ch }
    end

    def update(elapsed_time); end
  end
end
