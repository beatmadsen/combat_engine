module CombatEngine
  # Battle does bla TODO
  class Battle
    # Eigenclass state
    @battles = Set.new

    class << self
      def lookup(character:)
        @battles.find { |b| b.participant?(character) }
      end

      def end_battle(b)
        @battles.delete(b)
      end

      # idempotent: does nothing if mathing battle already exists
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

      def update(elapsed_time)
        @battles.each { |b| b.update(elapsed_time) }
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

    def update(_elapsed_time)
      @teams.each_value do |members|
        if members.sum(&:hp) <= 0
          Battle.end_battle(self)
          break
        end
      end
    end
  end
end
