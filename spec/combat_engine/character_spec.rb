require 'spec_helper'

RSpec.describe CombatEngine::Character do
  context 'when we have a target' do
    let(:target) { described_class.new }

    context 'when outside of battle' do
      context 'when healing a target' do
        def do_heal
          subject.fire_action(action_name: :demo_heal, target: target)
          subject.update(1)
        end
        it 'restores target hps' do
          expect { do_heal }.to change { target.hp }.by 1
        end
      end

      context 'when attacking a target' do
        def do_attack
          subject.fire_action(action_name: :demo_attack, target: target)
          subject.update(33)
        end

        it 'triggers a battle' do
          expect { do_attack }.to(
            change { target.battle }
              .from(nil)
              .to(CombatEngine::Battle)
          )
        end

        it 'does damage' do
          expect { do_attack }.to change { target.hp }.by(-1)
        end
      end
    end
  end
end
