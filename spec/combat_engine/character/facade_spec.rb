# frozen_string_literal: true

RSpec.describe CombatEngine::Character::Facade do
  def create_character(**options)
    Examples::Character.new(**options)
  end

  let(:character_unwrapped) { create_character(team: :a, hp: 100) }
  let(:character) { character_unwrapped.combat_facade }

  describe '#damage' do
    context 'when character is in battle with team mate tank' do
      let(:tank) { create_character(team: :a, hp: 100).combat_facade }
      let(:enemy) { create_character(team: :b, hp: 100).combat_facade }

      before do
        character.start_or_join_battle_with(tank, enemy)
      end
      context 'when tank has activated protection effect' do
        before do
          tank.fire_action(
            factory: Examples::TankProtectionAction,
            target: character
          )
        end
        it 'reduces the damage to the protected character' do
          expect do
            character.damage(attribute: :hp, amount: 50)
          end.to change { character.attribute(:hp) }.by(-25)
        end
        it 'lets the tank take some of the damage' do
          expect do
            character.damage(attribute: :hp, amount: 50)
          end.to change { tank.attribute(:hp) }.by(-25)
        end
      end
    end
  end

  describe '#fire_action' do
    context 'when character outside of battle' do
      context 'when we have a target' do
        let(:target_unwrapped) { create_character(team: :b, hp: 100) }
        let(:target) { target_unwrapped.combat_facade }
        context 'when healing target' do
          def do_heal
            character.fire_action(factory: Examples::Heal, target: target)
          end
          it 'restores target hps' do
            expect { do_heal }.to change { target.attribute(:hp) }.by 1
          end
        end

        context 'when target has an active strength effect' do
          before do
            target.receive_effect(
              factory: Examples::StrengthEffect, source: target, duration: 100
            )
          end
          context 'when dispelling effect from target' do
            # emulate that an effect was selected via some representation in GUI
            let(:strength_effect) { target.active_effects.first }
            def do_dispel
              character.fire_action(
                factory: Examples::Dispel,
                target: target,
                effect: strength_effect
              )
            end
            it 'removes strenght modifier from target' do
              expect { do_dispel }.to(
                change { target.attribute(:strength) }.from(90).to(100)
              )
            end
          end
        end

        def do_attack
          character.fire_action(factory: Examples::Attack, target: target)
        end
        context 'when target is not in battle' do
          context 'when attacking target' do
            it 'triggers a battle' do
              expect { do_attack }.to(
                change { character.battle }
                .from(nil)
                .to(CombatEngine::Battle::Base)
              )
            end

            it 'adds target to character\'s battle' do
              do_attack
              expect(target.battle).to eq(character.battle)
            end

            it 'does damage' do
              expect { do_attack }.to change { target.attribute(:hp) }.by(-1)
            end
          end
        end

        context 'when target is already in battle' do
          let(:friend) { create_character(team: :a, hp: 100).combat_facade }

          before do
            friend.fire_action(factory: Examples::Attack, target: target)
          end

          context 'when attacking target' do
            it 'puts character in battle' do
              expect { do_attack }.to(
                change { character.battle }
                .from(nil)
                .to(CombatEngine::Battle::Base)
              )
            end

            it 'adds character to target\'s battle' do
              do_attack
              expect(character.battle).to eq(target.battle)
            end

            it 'does damage' do
              expect { do_attack }.to change { target.attribute(:hp) }.by(-1)
            end
          end

          context 'when target gets immunity after winning a battle' do
            before do
              target.receive_effect(factory: Examples::ImmunityOnWinEffect)
            end

            context 'when target just won a battle' do
              before do
                friend.damage(attribute: :hp, amount: 100_000_000)
                target.battle.update(1)
              end

              context 'when immunity time has passed' do
                before do
                  target_unwrapped.update(
                    Examples::ImmunityEffect::DURATION + 1
                  )
                end
                it 'initiates a new battle' do
                  expect do
                    do_attack
                  end.to(
                    change { target.battle }.from(nil)
                      .to(CombatEngine::Battle::Base)
                  )
                end
              end

              context 'when immunity is still active' do
                it 'fails to execute attack' do
                  expect do
                    do_attack
                  end.to_not(change { target.battle })
                end
              end
            end
          end
        end
      end

      context 'when we have multiple targets' do
        let(:number_of_targets) { 5 }
        let(:targets) do
          (1..number_of_targets).map do
            create_character(team: :b, hp: 100).combat_facade
          end
        end
        def do_attack
          character.fire_action(factory: Examples::AoeAttack, targets: targets)
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
                change do
                  targets.sum { |c| c.attribute(:hp) }
                end.by(-1 * targets.size)
              )
            end
          end
        end
        context 'when some of the targets are already in battle' do
          let(:some_of_the_targets) do
            n = number_of_targets / 2
            targets[1..n]
          end
          let(:friend) { create_character(team: :a, hp: 100).combat_facade }
          before do
            some_of_the_targets.each do |target|
              friend.fire_action(factory: Examples::Attack, target: target)
            end
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
                change do
                  targets.sum { |c| c.attribute(:hp) }
                end.by(-1 * targets.size)
              )
            end
          end
        end
      end
    end

    context 'when character is already in battle' do
      let(:enemy) { create_character(team: :b, hp: 100).combat_facade }
      before do
        character.start_or_join_battle_with(enemy)
      end

      context 'when target has an active warding effect' do
        let(:other_enemy) { create_character(team: :b, hp: 100).combat_facade }
        before do
          other_enemy.fire_action(
            factory: Examples::WardingAction,
            target: enemy
          )
        end

        def do_attack
          character.fire_action(factory: Examples::Attack, target: enemy)
        end

        it 'fails to execute attack' do
          do_attack
          expect(character.last_action_status).to eq(:failed)
        end

        it 'does no damage' do
          expect do
            do_attack
          end.to_not(change { enemy.attribute(:hp) })
        end

        it 'succeeds with action that is beneficial to target' do
          character.fire_action(factory: Examples::Heal, target: enemy)
          expect(
            character.last_action_status
          ).to eq(:successful)
        end
      end
    end
  end
end
