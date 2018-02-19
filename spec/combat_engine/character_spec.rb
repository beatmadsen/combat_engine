# frozen_string_literal: true

RSpec.describe CombatEngine::Character do
  let(:character_unwrapped) { Examples::Character.new(team: :a, hp: 100) }
  let(:character) { character_unwrapped.combat_facade }

  describe '#update' do
    context 'when character has an active DOT effect' do
      let(:dot_interval) { Examples::DotEffect::INTERVAL }
      let(:dot_damage) do
        # damage per charge/activation
        Examples::DotEffect::DAMAGE
      end
      let(:dot_charges) { Examples::DotEffect::CHARGES }
      let(:enemy) { Examples::Character.new(team: :b, hp: 12).combat_facade }
      before do
        enemy.fire_action(factory: Examples::DotAttack, target: character)
      end
      context 'when elapsed time is greater than DOT damage interval' do
        let(:elapsed_time) { dot_interval + 1 }

        it 'applies damage to character' do
          # expect damage to be applied once, because there's an offset
          expect do
            character_unwrapped.update(elapsed_time)
          end.to change { character.attribute(:hp) }.by(-dot_damage)
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
              character_unwrapped.update(elapsed_time)
            end.to(
              change do
                character.attribute(:hp)
              end.by(-dot_damage * dot_charges)
            )
          end
        end

        context 'when running time is spent across multiple updates' do
          let(:number_of_updates) { 100 }
          let(:elapsed_time) { running_time / number_of_updates }
          it 'removes effect from character' do
            # test that no damage happens after last charge
            expect do
              number_of_updates.times do
                character_unwrapped.update(elapsed_time)
              end
            end.to(
              change { character.attribute(:hp) }.by(-dot_damage * dot_charges)
            )
          end
        end
      end
    end

    # TODO: test stacking of effect
    context 'when character has a strength attribute' do
      let(:enemy) { Examples::Character.new(team: :b, hp: 12).combat_facade }
      let!(:initial_strength) { character.attribute(:strength) }

      context 'when character has an active strength reduction' do
        let(:duration) { 200 }
        before do
          enemy.fire_action(
            factory: Examples::StrengthAction,
            target: character,
            duration: duration
          )
        end
        context 'when running time is less than lifetime' do
          it 'maintains reduced strength' do
            character_unwrapped.update(duration - 1)
            expect(character.attribute(:strength)).to be < initial_strength
          end
        end

        context 'when running time surpases effect lifetime' do
          it 'restores initial strength' do
            expect do
              character_unwrapped.update(duration + 1)
            end.to change { character.attribute(:strength) }.to initial_strength
          end
        end
      end
      context 'when character has two active strength reductions' do
        let(:durations) { [200, 100] }
        let(:f) { Examples::StrengthEffect::FACTOR }
        before do
          durations.each do |d|
            enemy.fire_action(
              factory: Examples::StrengthAction,
              target: character,
              duration: d
            )
          end
        end
        context 'when running time is less than either lifetime' do
          it 'stacks the modifiers' do
            character_unwrapped.update(durations.min - 1)
            expect(character.attribute(:strength)).to(
              eq(initial_strength * f * f)
            )
          end
        end
        context 'when running time is in between the two lifetimes' do
          it 'maintains reduced strength from remaining modifier' do
            character_unwrapped.update(durations.min + 1)
            expect(character.attribute(:strength)).to(
              eq(initial_strength * f)
            )
          end
        end
        context 'when running time surpases both lifetimes' do
          it 'restores initial strength' do
            expect do
              character_unwrapped.update(durations.max + 1)
            end.to change { character.attribute(:strength) }.to initial_strength
          end
        end
      end
    end
  end
end
