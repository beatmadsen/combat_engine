RSpec.describe CombatEngine::Character do
  context 'when subject outside of battle' do
    context 'when we have a target' do
      let(:target) { described_class.new }
      context 'when healing target' do
        def do_heal
          subject.fire_action(action_name: :demo_heal, target: target)
          subject.update(1)
        end
        it 'restores target hps' do
          expect { do_heal }.to change { target.hp }.by 1
        end
      end

      def do_attack
        subject.fire_action(action_name: :demo_attack, target: target)
        subject.update(33)
      end
      context 'when target is not in battle' do
        context 'when attacking target' do
          it 'triggers a battle' do
            expect { do_attack }.to(
              change { subject.battle }
              .from(nil)
              .to(CombatEngine::Battle)
            )
          end

          it 'adds target to subject\'s battle' do
            do_attack
            expect(target.battle).to eq(subject.battle)
          end

          it 'does damage' do
            expect { do_attack }.to change { target.hp }.by(-1)
          end
        end
      end

      context 'when target is already in battle' do
        let(:friend) { described_class.new }

        before do
          friend.fire_action(action_name: :demo_attack, target: target)
          friend.update(100)
        end

        context 'when attacking target' do
          it 'puts subject in battle' do
            expect { do_attack }.to(
              change { subject.battle }
              .from(nil)
              .to(CombatEngine::Battle)
            )
          end

          it 'adds subject to target\'s battle' do
            do_attack
            expect(subject.battle).to eq(target.battle)
          end

          it 'does damage' do
            expect { do_attack }.to change { target.hp }.by(-1)
          end
        end
      end
    end

    context 'when we have multiple targets' do
      let(:targets) { (1..3).map { described_class.new } }
      context 'when attacking multiple targets' do
        def do_attack
          subject.fire_action(action_name: :demo_aoe_attack, targets: targets)
          subject.update(5)
        end

        it 'adds all targets to same battle' do
          do_attack
          target_battles = targets.map(&:battle).compact
          expect(target_battles).to match_array([subject.battle] * 3)
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
