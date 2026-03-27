# Troubleshooting — gdpr-review

## Problem: Artifact contains no obvious personal data references
**Cause:** The feature may process personal data indirectly (e.g., via analytics, logging, error tracking) or the artifact doesn't describe data handling in detail.
**Solution:** Don't assume no data processing. Probe for indirect signals: logging user actions, storing IP addresses, session tracking, third-party integrations that collect data. Ask the user: *"The artifact doesn't explicitly mention personal data. Does this feature involve any user tracking, logging, or third-party services that might process personal data?"*

## Problem: Legal basis is ambiguous for a processing activity
**Cause:** Multiple Art. 6 bases could apply, or the purpose isn't specific enough to determine the correct one.
**Solution:** Present the options to the user with pros/cons for each basis. Consult EDPB guidance via `WebSearch` for the specific processing scenario. Log the decision to DECISION.md.

## Problem: Prior GDPR-REVIEW.md exists but the reviewed artifact has changed significantly
**Cause:** The SPEC or BRIEF was updated after the last review.
**Solution:** Run a full review (not just a diff). In the output, mark findings as "Previously identified" or "New finding" so the user can see what changed. Note in the header: *"Prior review exists but the source artifact has changed — running full re-review."*

## Problem: DECISION.md contains a decision that conflicts with GDPR requirements
**Cause:** A prior decision may have been made without considering GDPR implications.
**Solution:** Flag the conflict explicitly: *"Decision {N} says X, but GDPR Article {Y} requires Z. This needs resolution."* Never silently override a logged decision. Log the conflict and resolution to DECISION.md.

## Problem: Feature processes special category data (Art. 9)
**Cause:** The feature handles health, biometric, genetic, racial, political, religious, trade union, sexual orientation, or criminal data.
**Solution:** Flag immediately — special category data requires explicit consent or another Art. 9(2) exemption. A DPIA is almost certainly required. Recommend consulting a DPO before proceeding with spec or plan generation.

## Problem: WebSearch returns outdated GDPR guidance
**Cause:** GDPR guidance evolves through EDPB opinions and CJEU rulings.
**Solution:** Prefer EUR-Lex for the regulation text (stable) and EDPB for the latest guidelines. Check the publication date of any guidance cited. If guidance is older than 2 years, note it: *"This guidance is from {year} — check EDPB for more recent opinions."*

## Problem: Feature involves international data transfers
**Cause:** Data may be stored or processed outside the EEA (cloud providers, CDNs, third-party APIs).
**Solution:** Flag the transfer and check: (1) adequacy decision for the destination country, (2) Standard Contractual Clauses, (3) Binding Corporate Rules. If using US cloud providers, check the current EU-US Data Privacy Framework status via `WebSearch`.

## Problem: User disagrees with the risk assessment
**Cause:** The user may have additional context about their organization's data protection practices.
**Solution:** Adjust the assessment based on the user's input. Log the override to DECISION.md with the user's reasoning. The review is advisory — the user's judgment prevails.
