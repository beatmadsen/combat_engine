RSpec.describe CombatEngine::Game do
  describe '.update' do
    context 'when there are ongoing battles' do
      let(:battles) do
        (1..3).map do
          a = CombatEngine::Character.new(team: :a, hp: 1)
          b = CombatEngine::Character.new(team: :b, hp: 1)
          a.start_or_join_battle_with(b)
          a.battle
        end
      end

      it 'updates them all' do
        battles.each do |b|
          expect(b).to receive(:update)
        end
        described_class.update(1)
      end
    end

    context 'when game has characters' do
      let(:characters) { (1..3).map { double } }
      before do
        described_class.add_characters(characters)
      end

      it 'updates them all' do
        characters.each do |c|
          expect(c).to receive(:update)
        end
        described_class.update(1)
      end
    end
  end
end
