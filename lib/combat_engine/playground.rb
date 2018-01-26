# CombatEngine top-level comment bla
module CombatEngine
  # Test-driven roadmap:
  # -----------------
  # Step 1: (✓)
  # Heal someone outside of battle
  #
  # Step 2: (✗)
  #
  #   Step 2.1: (✓)
  #   Attack someone and trigger battle
  #
  #   Step 2.2: (✗)
  #   Launch an area attack with 3 targets and trigger battle
  #
  # Step 3: (✗)
  # Attack somone who is already in battle and join that battle
  #
  # Step 4: (✗)
  # End battle when all opponents have zero hp
  #
  # Step 5: (✗)
  # Battle with 3 teams
  #
  # Step 6: (✗)
  # Schedule a DOT effect
  #
  # Step n-1: (✗)
  # Make battle resolution rules pluggable
  #
  # Step n: (✗)
  # Make action lookup pluggable
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
