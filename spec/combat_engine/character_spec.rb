# frozen_string_literal: true

RSpec.describe CombatEngine::Character do
  subject { DemoCharacter.new }
  let(:player_two) { DemoCharacter.new }

  context 'when player 2 attacks subject to deal instant damage' do
    before do
      player_two.perform(DemoAttack, subject)
    end
    it { is_expected.to have_attributes(hp: 90) }
  end
end
