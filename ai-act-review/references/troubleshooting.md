# Troubleshooting — ai-act-review

## Problem: Feature doesn't obviously use AI
**Cause:** The artifact may use AI indirectly (via third-party APIs, embedded models, or automated decision-making that isn't labeled as "AI").
**Solution:** Probe for indirect signals: third-party APIs with ML capabilities (e.g., cloud vision APIs, recommendation services), automated scoring or ranking, dynamic personalization, content generation. Ask: *"Does this feature use any third-party services that include AI/ML components, or any automated decision-making logic?"*

## Problem: Risk classification is ambiguous
**Cause:** The AI system doesn't clearly fit into one Annex III category, or the use case is borderline.
**Solution:** Present the ambiguity to the user with the closest categories and their implications. Consult EU AI Office guidance via `WebSearch` for similar use cases. Log the classification decision to DECISION.md with full reasoning.

## Problem: AI Act provisions are not yet in force for this risk category
**Cause:** The phased implementation means some obligations only apply from 2026 or 2027.
**Solution:** Note the current applicability in the review: *"This provision (Art. {N}) takes effect on {date}. The feature should be designed for compliance now to avoid retrofitting."* Recommend implementing ahead of the deadline.

## Problem: Feature uses a general-purpose AI model (e.g., GPT, Claude, Gemini)
**Cause:** General-purpose AI models have specific obligations under Art. 51-55 for the provider, but the feature may be a deployer using the model via API.
**Solution:** Distinguish between provider and deployer obligations. If the feature calls an external AI API, the feature team is a deployer — their obligations focus on transparency (Art. 50) and appropriate use, not on model documentation. Note: *"This feature deploys a general-purpose AI model via API. Provider obligations (Art. 53) fall on {provider name}. Deployer obligations (Art. 50, transparency) apply to this feature."*

## Problem: Prior AI-ACT-REVIEW.md exists but the AI component has changed
**Cause:** The SPEC was updated with different AI capabilities.
**Solution:** Run a full review. The risk classification may have changed (e.g., from limited to high-risk). Mark findings as "Previously identified" or "New finding" and flag any risk level changes: *"Risk classification changed from {old} to {new} due to {change}."*

## Problem: DECISION.md contains a decision conflicting with AI Act requirements
**Cause:** A prior decision may predate the AI Act review.
**Solution:** Flag: *"Decision {N} says X, but AI Act Art. {Y} requires Z."* Never silently override a logged decision.

## Problem: WebSearch returns conflicting guidance about AI Act interpretation
**Cause:** The AI Act is new and interpretive guidance is still developing.
**Solution:** Prefer EUR-Lex for the regulation text (authoritative). For interpretive questions, cite the EU AI Office or EDPB. If guidance conflicts, present both interpretations and note: *"Interpretation is evolving — consult legal counsel for definitive guidance on this point."*

## Problem: Feature operates outside the EU
**Cause:** The AI Act applies to AI systems placed on the EU market or whose output is used in the EU, regardless of where the provider is established.
**Solution:** The AI Act has extraterritorial scope (Art. 2). If the feature's output is used by persons in the EU, the AI Act applies. Note this in the review if the user assumes non-applicability.
