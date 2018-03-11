# frozen_string_literal: true
RSpec.describe CombatEngine::Battle do
  describe '.update' do
    before do
      described_class.start_or_join(participants: initial_participants)
    end
    context 'when there\'s an ongoing battle' do
      let(:remaining_hp) { 5 }
      let(:initial_participants) do
        (%i[a b c] * 3).map do |team|
          Examples::Character.new(team: team, hp: remaining_hp).combat_facade
        end
      end

      context 'when only one team\'s members have lost all hp' do
        before do
          initial_participants.each do |c|
            next unless c.team == :a
            c.damage(attribute: :hp, amount: remaining_hp)
          end
        end

        let(:battle) { initial_participants.first.battle }
        it 'should not end battle' do
          described_class.update(1)
          remaining_battles = initial_participants.map(&:battle).compact.uniq
          expect(remaining_battles).to eq([battle])
        end
      end

      context 'when all teams but one have lost all hp' do
        before do
          initial_participants.each do |c|
            next if c.team == :c
            c.damage(attribute: :hp, amount: remaining_hp)
          end
        end

        it 'should end battle' do
          described_class.update(1)
          remaining_battles = initial_participants.map(&:battle).compact
          expect(remaining_battles).to be_empty
        end
      end

      context 'when all teams still have members with hp' do
        before do
          team_a = initial_participants.select { |c| c.team == :a }
          team_b = initial_participants.select { |c| c.team == :b }
          team_c = initial_participants.select { |c| c.team == :b }
          # Leave one member on each team with hp
          (team_a[1..-1] + team_b[1..-1] + team_c[1..-1]).each do |c|
            c.damage(attribute: :hp, amount: remaining_hp)
          end
        end

        let(:battle) { initial_participants.first.battle }
        it 'should not end battle' do
          described_class.update(1)
          remaining_battles = initial_participants.map(&:battle).compact.uniq
          expect(remaining_battles).to eq([battle])
        end
      end
    end
  end

  describe '.start_or_join' do
    context 'when there are members from more than 2 teams' do
      let(:characters) do
        (%i[a b c] * 5).map do |team|
          Examples::Character.new(team: team, hp: 10).combat_facade
        end
      end

      # TODO: what if party members are not from same team?
      # Idea: Party takes precedence when identifying
      # which side a player belongs to in a battle
      # NB: since players can join battle later, their side needs to
      # be evaluated according to same rules
      context 'when some team members are in parties' do
        let(:party_members) { characters.take(3) }
        before do
          CombatEngine::Party.create_or_join(members: party_members)
        end
        let(:first_guy) { party_members.first }

        it 'lets the party dictate which team they fight on' do
          expect do
            described_class.start_or_join(participants: characters)
          end.to(
            change { first_guy.battle_allies }
              .from(nil)
              .to(party_members - [first_guy])
          )
        end

        xit '8.4' do
          raise 'no'
        end
      end
      context 'when there are no parties' do
        it 'allows them all to participate in same battle' do
          described_class.start_or_join(participants: characters)
          active_battles = characters.map(&:battle)
          first_battle = characters.first.battle
          expect(active_battles).to match_array(
            [first_battle] * characters.size
          )
        end
      end
    end
  end
end
