# CombatEngine top-level comment bla
module CombatEngine
  # Test-driven roadmap:
  # -----------------
  # Step 1: (✓)
  # Heal someone outside of battle
  #
  # Step 2: (✗)
  # Attack somone and trigger battle
  #
  # Step 3: (✗)
  # Attack somone who is already in battle and join that battle
  #
  # Step 4: (✗)
  # Make battle resolution rules pluggable
  # -----------------

  # Simplest idea:
  # -----------------
  # Friendly actions cannot initiate battles,
  # but are allowed in existing battles
  #
  # Hostile actions initiate battle if none exist
  # and battle with all targets is possible
  #
  # Battle with all targets is only possible if none are in battle
  # or they're all part of the same battle
  # -----------------
  #
  # Problem: How can you heal someone outside of battle?
  # Conclusion: actions are not necessarily run within a battle context
end
