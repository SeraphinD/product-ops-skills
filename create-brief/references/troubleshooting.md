# Troubleshooting — create-brief

## Problem: BRIEF.md already exists at the target path
**Cause:** A previous session or manual creation left a file at `docs/features/{feature-name}/BRIEF.md`.
**Solution:** The skill will inform you and ask for confirmation before overwriting. If you want to keep the old version, rename it manually before proceeding.

## Problem: User provides all info in one message and expects instant output
**Cause:** The skill is designed to be interactive — it works section by section.
**Solution:** Even with rich context, the skill will still propose each section as a draft and ask for confirmation. This ensures quality. If the user explicitly requests "generate it all at once", remind them that section-by-section confirmation catches errors early.

## Problem: Fewer than 3 objectives or success criteria
**Cause:** The brief's scope is narrow or the user hasn't thought deeply about goals.
**Solution:** Ask targeted questions: "What else should this feature achieve beyond what we've covered? Any technical, operational, or process goals?" If the user genuinely has fewer, explain the minimum range (3–7 objectives, 3–8 criteria) and help them reach it.

## Problem: Success criteria are vague or not binary
**Cause:** User provides subjective criteria like "app should feel fast" or "good error handling".
**Solution:** Push for specifics: "What exact behavior would you check? Can you frame it as a pass/fail test?" Transform vague criteria into binary, verifiable statements.

## Problem: In-scope items are too vague
**Cause:** User describes scope in abstract terms like "good UX" or "proper API design" instead of concrete deliverables.
**Solution:** Ask for specifics: *"What exact components, commands, outputs, or behaviors should this include?"* Each in-scope item should be a concrete deliverable someone could verify as done or not done.

## Problem: PROBLEM-FRAME.md exists but contradicts user's description
**Cause:** The user's current thinking has evolved since the problem frame was created.
**Solution:** Flag the conflict: *"The problem frame says X, but you're describing Y. Which should the brief follow?"* Log the decision to DECISION.md. If the problem frame is outdated, the brief follows the user's current intent.

## Problem: Out-of-scope items are hard to identify
**Cause:** The user hasn't considered what adjacent features or assumptions might creep into scope.
**Solution:** Prompt with categories: *"What about: related features people might expect? Future iterations you want to defer? Platform or device support you're excluding? Integrations you're not building yet?"*
