# frozen_string_literal: true
require_relative 'battle/base'
require_relative 'battle/done_state'
require_relative 'battle/running_state'
require_relative 'battle/victory_state'

module CombatEngine
  # Battle does bla TODO
  module Battle
    # Eigenclass state
    @battles = Set.new

    class << self
      def lookup(character:)
        @battles.find { |b| b.participant?(character) }
      end

      def end_battle(b)
        @battles.delete(b)
      end

      # idempotent: does nothing if matching battle already exists
      def start_or_join(participants:)
        active_battles = active_battles(participants)
        if active_battles.one?
          active_battles.first.add_participants(*participants)
        elsif active_battles.empty?
          @battles << Base.new(participants: participants)
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
  end
end
