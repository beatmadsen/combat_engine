# frozen_string_literal: true

module CombatEngine
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
    end

    def initialize(members:)
      @members = Set.new
      add_members(*members)
    end

    def add_members(*ms)
      @members.merge(ms)
    end

    def member?(m)
      @members.include?(m)
    end
  end
end
