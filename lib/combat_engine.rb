
Dir.glob(
  File.join(__dir__, 'combat_engine', '**', '*.rb')
).each { |file| require file }

# CombatEngine does bla TODO
module CombatEngine
end
