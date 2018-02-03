RSpec.describe CombatEngine::Action::CharacterFacade do
  let(:character) do
    CombatEngine::Character.new(team: :a, hp: 100).facade(:action)
  end

  describe '#damage' do
    context 'when character is in battle with team mate tank' do
      let(:tank) { CombatEngine::Character.new(team: :a, hp: 100) }
      let(:enemy) { CombatEngine::Character.new(team: :b, hp: 100) }

      before do
        character.start_or_join_battle_with(tank, enemy)
      end
      context 'when tank has activated protection effect' do
        before do
          tank.fire_action(
            factory: Examples::TankProtectionAction,
            target: character
          )
          tank.update(1)
        end
        it 'reduces the damage to the protected character' do
          expect do
            character.damage(attribute: :hp, amount: 50)
            character.update(1)
          end.to change { character.hp }.by(-25)
        end
        it 'lets the tank take some of the damage' do
          expect do
            character.damage(attribute: :hp, amount: 50)
            character.update(1)
          end.to change { tank.hp }.by(-25)
        end
      end
    end
  end
end
