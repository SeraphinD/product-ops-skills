# Troubleshooting — brief-to-opportunity

## Problem: User proposes a non-Fibonacci value for Impact or Effort
**Cause:** Fibonacci scale is unfamiliar or the user feels "in between" two values.
**Solution:** Show the nearest Fibonacci options: "7 isn't on the Fibonacci scale. Would you prefer 5 (Significant) or 8 (High)?" Explain that Fibonacci forces deliberate choices and prevents false precision.

## Problem: BRIEF.md not found
**Cause:** The file doesn't exist at the expected path.
**Solution:** Ask: "Which BRIEF.md should I score?" If the BRIEF hasn't been created yet, suggest using the `create-brief` skill first.

## Problem: Reach percentage is hard to estimate
**Cause:** The brief doesn't quantify the target audience or the user base is poorly defined.
**Solution:** Ask the user to estimate: *"Roughly what fraction of your users would encounter or benefit from this feature in a quarter?"* If they can't answer, check the BENCHMARK.md for comparable adoption data. As a last resort, use a conservative estimate and lower Confidence to 50%.

## Problem: All impact dimensions score high (potential inflation)
**Cause:** The user is enthusiastic about the feature and scores everything as 8 or 13.
**Solution:** Gently calibrate: *"If everything scores High or Transformative, the scale loses its value. Can we compare this to another feature you've built — how does this one rank relative to that?"* Reference the Fibonacci meaning table: 13 = Transformative means it fundamentally changes the business.

## Problem: Effort estimate varies wildly between team members
**Cause:** Different mental models of what's in scope or different skill levels.
**Solution:** Anchor effort to the brief's In Scope items: *"Based on the {N} in-scope deliverables, I'd estimate {X} person-weeks. Does that match your team's capacity?"* If there's genuine disagreement, lower Confidence.

## Problem: BENCHMARK.md has unverified data
**Cause:** The benchmark phase flagged some metrics as `⚠️ Unverified`.
**Solution:** Use only verified data to support score rationale. If unverified data would significantly change a score, note it but keep Confidence at 50% or 80%. Never use unverified benchmarks to justify 100% Confidence.

## Problem: OPPORTUNITY.md already exists and user wants to re-score
**Cause:** Circumstances changed since the original scoring.
**Solution:** The skill will detect the existing file and ask before overwriting. Show the old RICE score for comparison. Log the re-scoring decision and reason to DECISION.md.
