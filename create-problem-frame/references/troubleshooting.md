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

## Problem: User provides too much research data
**Cause:** The user dumps 20+ interview transcripts, massive CSV exports, or dozens of files. Processing all of it would make the session unwieldy.
**Solution:** Ask the user to narrow the input: *"That's a lot of data — can you point me to the 5–8 most relevant sources, or provide a pre-summary of the key themes you've already noticed?"* Focus on the most recent, most representative, or most relevant sources.

## Problem: Research data contradicts the user's intuition
**Cause:** The user believes the problem is X, but the research data points to Y. This tension is valuable.
**Solution:** Surface the contradiction explicitly. Don't suppress data to match the user's framing. Present both perspectives: *"The data suggests [Y], but you initially described the problem as [X]. These point in different directions — which one should we dig into?"* This often leads to the most valuable problem frames.

## Problem: Research data is low quality or insufficient
**Cause:** Small sample size, stale data, or anecdotal evidence presented as research.
**Solution:** Accept the data but rate confidence as Low in the Research Evidence section. Flag gaps explicitly in the Data Gaps subsection. Proceed with the frame but note it in the Stress Test: *"Evidence basis: Limited data — 3 interviews from 6 months ago."* Suggest what additional research would strengthen the frame.

## Problem: User provides no research but has data available somewhere
**Cause:** The user says "we probably have support tickets" or "someone did interviews last quarter" but doesn't provide the data.
**Solution:** Don't block on missing data. Proceed without Research Evidence but add the unavailable sources to Data Gaps: *"Support ticket data exists but was not analyzed for this frame."* This creates a natural prompt for future research.
