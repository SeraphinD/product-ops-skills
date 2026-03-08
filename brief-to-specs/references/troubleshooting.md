# Troubleshooting — brief-to-specs

## Problem: BRIEF is too vague to write precise acceptance criteria
**Cause:** The brief uses generic language like "handle errors properly" without specifying error messages, codes, or formats.
**Solution:** Ask all clarifying questions in a single message before writing. Propose sensible defaults: "The brief says 'show an error for invalid input' but doesn't specify the format. I'll default to `{ "error": "Invalid input: {reason}" }` unless you tell me otherwise."

## Problem: User disagrees with WSJF scoring
**Cause:** WSJF scores are relative estimates — reasonable people can disagree.
**Solution:** The scorecard is a recommendation, not a verdict. When the user overrides a label, accept it immediately, log the override to DECISION.md with the user's reasoning, and move on.

## Problem: Can't determine if a story is one US or should be split
**Cause:** The brief describes multiple capabilities that could be one big story or multiple smaller ones.
**Solution:** Apply the rule: split only when there are genuinely different actors OR fundamentally different capabilities. If the same actor does related things, keep as one US with a broader Functional Scope. Ask the user when genuinely ambiguous.

## Problem: BENCHMARK.md contains unverified metrics
**Cause:** The benchmark phase flagged some data as `⚠️ Unverified`.
**Solution:** Ignore unverified metrics — do not carry them into the SPEC as if verified. Use only verified baselines for concrete AC values. If the user wants to use an unverified metric, log the decision to DECISION.md.

## Problem: Brief objectives don't map cleanly to user stories
**Cause:** The brief's objectives are high-level business goals rather than user-facing capabilities.
**Solution:** Translate objectives into actor + capability pairs. An objective like "Reduce onboarding time by 50%" becomes a user story: "As a new user, I can complete onboarding in under 3 minutes." If an objective has no user-facing component, it may belong in Implementation Notes rather than as a User Story.

## Problem: Too many MUST stories — everything feels critical
**Cause:** The user or brief treats all features as equally important.
**Solution:** Ask the user: *"If you could ship only 3 of these stories, which 3 would they be?"* Those are MUST; the rest are likely SHOULD. Use WSJF scoring to surface the objective ranking. Remind them that MUST means "the feature is broken without this."

## Problem: Acceptance criteria overlap between stories
**Cause:** Two user stories share underlying functionality (e.g., both need authentication).
**Solution:** Assign the shared AC to the story where it's most naturally discovered. In the other story's ACs, reference it: *"Given the user is authenticated (see US-1)."* Avoid duplicating the same Given/When/Then across stories.

## Problem: SPEC gaps trace back to BRIEF problems
**Cause:** The brief is missing information that the SPEC needs (e.g., no error handling strategy, unclear target audience).
**Solution:** Flag to the user: *"This SPEC gap traces back to the BRIEF. Should I update the BRIEF first, then regenerate the affected SPEC sections?"* See the Pipeline Iteration & Rollback section for the full protocol.
