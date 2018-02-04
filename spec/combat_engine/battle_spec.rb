# frozen_string_literal: true

RSpec.describe CombatEngine::Battle do
  describe '.update' do
    before do
      described_class.start_or_join(participants: initial_participants)
    end
    context 'when there\'s an ongoing battle' do
      let(:remaining_hp) { 5 }
      let(:initial_participants) do
        (%i[a b] * 3).map do |team|
          CombatEngine::Character.new(team: team, hp: remaining_hp)
        end
      end
      context 'when one team\'s members have lost all hp' do
        before do
          initial_participants.each do |c|
            next unless c.team == :a
            c.facade(:action).damage(attribute: :hp, amount: remaining_hp)
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
          # Leave one member on each team with hp
          (team_a[1..-1] + team_b[1..-1]).each do |c|
            c.facade(:action).damage(attribute: :hp, amount: remaining_hp)
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
          CombatEngine::Character.new(team: team, hp: 10)
        end
      end
      it 'allows them all to participate in same battle' do
        described_class.start_or_join(participants: characters)
        active_battles = characters.map(&:battle)
        first_battle = characters.first.battle
        expect(active_battles).to match_array([first_battle] * characters.size)
      end
    end
  end
end
