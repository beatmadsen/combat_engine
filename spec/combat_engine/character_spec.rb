RSpec.describe CombatEngine::Character do
  let(:character) { described_class.new(team: :a, hp: 100) }
  describe '#fire_action' do
    context 'when character outside of battle' do
      context 'when we have a target' do
        let(:target) { described_class.new(team: :b, hp: 100) }
        context 'when healing target' do
          def do_heal
            character.fire_action(factory: Examples::Heal, target: target)
            character.update(1)
          end
          it 'restores target hps' do
            expect { do_heal }.to change { target.hp }.by 1
          end
        end

        def do_attack
          character.fire_action(factory: Examples::Attack, target: target)
          character.update(33)
        end
        context 'when target is not in battle' do
          context 'when attacking target' do
            it 'triggers a battle' do
              expect { do_attack }.to(
                change { character.battle }
                .from(nil)
                .to(CombatEngine::Battle)
              )
            end

            it 'adds target to character\'s battle' do
              do_attack
              expect(target.battle).to eq(character.battle)
            end

            it 'does damage' do
              expect { do_attack }.to change { target.hp }.by(-1)
            end
          end
        end

        context 'when target is already in battle' do
          let(:friend) { described_class.new(team: :a, hp: 100) }

          before do
            friend.fire_action(factory: Examples::Attack, target: target)
            friend.update(100)
          end

          context 'when attacking target' do
            it 'puts character in battle' do
              expect { do_attack }.to(
                change { character.battle }
                .from(nil)
                .to(CombatEngine::Battle)
              )
            end

            it 'adds character to target\'s battle' do
              do_attack
              expect(character.battle).to eq(target.battle)
            end

            it 'does damage' do
              expect { do_attack }.to change { target.hp }.by(-1)
            end
          end
        end
      end

      context 'when we have multiple targets' do
        let(:number_of_targets) { 5 }
        let(:targets) do
          (1..number_of_targets).map { described_class.new(team: :b, hp: 100) }
        end
        def do_attack
          character.fire_action(factory: Examples::AoeAttack, targets: targets)
          character.update(5)
        end
        context 'when none of the targets are already in battle' do
          context 'when attacking targets' do
            it 'adds all targets to same battle' do
              do_attack
              target_battles = targets.map(&:battle).compact
              expect(target_battles).to match_array(
                [character.battle] * number_of_targets
              )
            end

            it 'does damage to all targets' do
              expect { do_attack }.to(
                change { targets.sum(&:hp) }.by(-1 * targets.size)
              )
            end
          end
        end
        context 'when some of the targets are already in battle' do
          let(:some_of_the_targets) do
            n = number_of_targets / 2
            targets[1..n]
          end
          let(:friend) { described_class.new(team: :a, hp: 100) }
          before do
            some_of_the_targets.each do |target|
              friend.fire_action(factory: Examples::Attack, target: target)
            end
            friend.update(100)
          end

          context 'when attacking targets' do
            it 'adds character and remaining targets to same battle' do
              do_attack
              target_battles = targets.map(&:battle).compact
              expect(target_battles).to match_array(
                [character.battle] * number_of_targets
              )
            end

            it 'does damage to all targets' do
              expect { do_attack }.to(
                change { targets.sum(&:hp) }.by(-1 * targets.size)
              )
            end
          end
        end
      end
    end
  end

  describe '#update' do
    context 'when character has an active DOT effect' do
      let(:dot_interval) { Examples::DotEffect::INTERVAL }
      let(:dot_damage) do
        # damage per charge/activation
        Examples::DotEffect::DAMAGE
      end
      let(:dot_charges) { Examples::DotEffect::CHARGES }
      let(:enemy) { described_class.new(team: :b, hp: 12) }
      before do
        enemy.fire_action(factory: Examples::DotAttack, target: character)
        enemy.update(1)
      end
      context 'when elapsed time is greater than DOT damage interval' do
        let(:elapsed_time) { dot_interval + 1 }

        it 'applies damage to character' do
          # expect damage to be applied once, because there's an offset
          expect do
            character.update(elapsed_time)
          end.to change { character.hp }.by(-dot_damage)
        end
      end

      context 'when running time surpases effect lifetime' do
        let(:lifetime) do
          dot_interval * dot_charges
        end
        let(:long_time) { dot_interval * dot_charges }
        let(:running_time) { lifetime + long_time }

        context 'when running time is spent in one update' do
          let(:elapsed_time) { running_time }
          it 'removes effect from character' do
            # test that no damage happens after last charge
            expect do
              character.update(elapsed_time)
            end.to change { character.hp }.by(-dot_damage * dot_charges)
          end
        end

        context 'when running time is spent across multiple updates' do
          let(:number_of_updates) { 100 }
          let(:elapsed_time) { running_time / number_of_updates }
          it 'removes effect from character' do
            # test that no damage happens after last charge
            expect do
              number_of_updates.times { character.update(elapsed_time) }
            end.to change { character.hp }.by(-dot_damage * dot_charges)
          end
        end
      end
    end
  end
end
