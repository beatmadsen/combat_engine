require 'spec_helper'

RSpec.describe CombatEngine::Character do
  context 'when we have a target' do
    let(:target) { described_class.new }

    context 'when outside of battle' do
      it 'can heal target' do
        expect do
          subject.fire_action(action_name: :demo_heal, target: target)
          subject.update(1)
        end.to change { target.hp }.by 1
      end
    end
  end
end
