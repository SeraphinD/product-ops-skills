# Troubleshooting — create-problem-frame

## Problem: User can't articulate the problem clearly
**Cause:** The problem is felt but not yet understood — this is exactly when problem framing is most valuable.
**Solution:** Start with concrete observations: *"What specific thing happened that made you think there's a problem? A user complaint? A metric change? Something you observed?"* Work from the concrete to the abstract.

## Problem: The 5 Whys goes in circles
**Cause:** Two causes are mutually reinforcing (A causes B, B causes A).
**Solution:** Acknowledge the loop, identify which node is more actionable, and designate it as the root cause. Log the circular dependency in the analysis.

## Problem: User insists on discussing solutions
**Cause:** Natural tendency to jump to fixes.
**Solution:** Acknowledge the solution, note it for later, and redirect: *"That's a good candidate solution — I'll note it. For now, let's make sure we've nailed the problem so we don't build the wrong thing."*

## Problem: PROBLEM-FRAME.md already exists
**Cause:** A previous session created one.
**Solution:** Inform the user and ask for confirmation before overwriting.

## Problem: Root cause feels too abstract to act on
**Cause:** The 5 Whys went too deep, reaching systemic or organizational causes that can't be addressed by a single feature.
**Solution:** Walk back one level and treat the previous "Why" as the actionable root cause. A root cause should be something the team can realistically influence. Log the deeper systemic cause as context in the Constraints section.

## Problem: Alternative framings all seem equally valid
**Cause:** The problem genuinely has multiple valid perspectives and no framing clearly dominates.
**Solution:** Ask the user which framing aligns best with their current priorities, team capacity, or strategic direction. If they can't decide, pick the framing that has the narrowest scope — it's easier to expand later than to narrow down.

## Problem: Situation context is too broad
**Cause:** The user describes an entire domain rather than a specific situation (e.g., "our authentication is a mess" instead of a specific trigger event).
**Solution:** Ask for the triggering event: *"What specific incident or observation made this a priority now?"* Ground the frame in a concrete moment, then expand scope deliberately.
