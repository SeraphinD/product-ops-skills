# Troubleshooting — brief-to-benchmark

## Problem: Web search returns no relevant results for comparable solutions
**Cause:** The feature domain is niche, or search queries are too specific.
**Solution:** Broaden search terms: try the problem domain rather than the feature name. Use queries like `{problem category} tools comparison` or `{industry} solutions for {pain point}`. If truly no comparables exist, note this honestly in the Comparable Solutions section and focus more on Technical Standards and Metrics.

## Problem: Metrics have no credible source
**Cause:** Industry baselines for the specific domain are not publicly available.
**Solution:** Mark with `⚠️ Unverified — validate before use` in the Source column. Include the metric anyway — an unverified baseline is more useful than no baseline. The spec writer can validate or discard it later.

## Problem: BRIEF.md not found
**Cause:** The file doesn't exist at the expected path, or the feature name doesn't match.
**Solution:** The skill will ask: "Which BRIEF.md should I use?" Provide the exact path. If the BRIEF hasn't been created yet, use the `create-brief` skill first.

## Problem: DECISION.md contains a decision that conflicts with benchmark findings
**Cause:** A prior decision may have been made before research was available.
**Solution:** Flag the conflict explicitly: "Decision {N} says X, but the research suggests Y. Which should take precedence?" Never silently override a logged decision.

## Problem: Too many comparable solutions found
**Cause:** The domain is crowded with existing tools or the search terms are too broad.
**Solution:** Prioritize the 3–5 most relevant comparables based on: direct overlap with the brief's problem statement, similar target audience, and most instructive differentiators. Mention runners-up briefly in Gap Analysis if they provide unique insights.

## Problem: Feature type is ambiguous (frontend vs backend)
**Cause:** The brief describes a feature with both frontend and backend components.
**Solution:** Ask the user: *"This feature has both frontend and backend aspects. Should I include Visual References for the UI patterns, or focus on the backend architecture?"* Log the decision.

## Problem: Competitor information is outdated
**Cause:** Web search returns content from years ago; the competitor may have changed significantly.
**Solution:** Note the date of the source in the comparable solution entry. If the data is more than 2 years old, mark it: *"⚠️ Data from {year} — may not reflect current state."* Try to find more recent sources before falling back to older ones.
