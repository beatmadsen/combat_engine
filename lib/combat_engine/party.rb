# frozen_string_literal: true

module CombatEngine
  # A party is a group of characters that have opted to fight together
  class Party
    @parties = Set.new
    class << self
      def lookup(character:)
        @parties.find { |p| p.member?(character) }
      end

      def create_or_join(members:)
        parties = members.map { |m| lookup(character: m) }
                         .tap(&:compact!)
                         .to_set
        if parties.empty?
          @parties << Party.new(members: members)
        elsif parties.one?
          parties.first.add_members(*members)
        else
          raise 'found multiple parties'
        end
      end

      def remove_member(m)
        lookup(character: m).remove_member(m)
      end
    end

    def initialize(members:)
      @members = Set.new
      add_members(*members)
    end

    def add_members(*ms)
      @members.merge(ms)
    end

    def remove_member(m)
      @members.delete(m)
      @members.clear if @members.one?
    end

    def member?(m)
      @members.include?(m)
    end
  end
end
