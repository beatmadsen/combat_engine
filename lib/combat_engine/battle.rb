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
        active_battles = active_battles(participants)
        if active_battles.one?
          active_battles.first.add_participants(*participants)
        elsif active_battles.empty?
          @battles << new(participants: participants)
        else
          raise 'suggested teams have members in multiple battles'
        end
      end

      private

      def active_battles(participants)
        participants.each_with_object(Set.new) do |c, acc|
          battle = lookup(character: c)
          acc << battle unless battle.nil?
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
      characters.each { |c| @teams[c.team] << c }
    end

    def update(elapsed_time); end
  end
end
