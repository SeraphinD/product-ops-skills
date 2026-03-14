# Troubleshooting — pm

## Problem: Multiple feature directories found, unclear which to use
**Cause:** The project has several features in `docs/features/` and the user didn't specify which one.
**Solution:** List all feature directories and ask the user to pick one. Do not guess.

## Problem: User asks "/pm" but no feature directories exist
**Cause:** The user hasn't started any feature yet, or artifacts are stored in a non-standard location.
**Solution:** Recommend starting with `create-problem-frame` or `create-brief`. If the user says artifacts exist elsewhere, ask for the path.

## Problem: User wants to skip a required stage
**Cause:** The user wants to jump from BRIEF to PLAN without generating a SPEC first.
**Solution:** Explain that the downstream skill (`spec-to-plan`) requires a `SPEC.md` as input. Recommend generating the spec first. Required stages cannot be skipped: BRIEF → SPEC → PLAN → TASKS.

## Problem: User wants to re-run a stage that already has output
**Cause:** Requirements changed and the user wants to regenerate a SPEC, PLAN, or other artifact.
**Solution:** The individual skill will handle the re-generation. Warn the user that downstream artifacts (PLAN, TASKS) may need to be regenerated too, since they were derived from the earlier version.

## Problem: Router recommends a skill the user doesn't have installed
**Cause:** The user installed only some of the pipeline skills.
**Solution:** Check which skills are actually available. If a required skill is missing, tell the user how to install it: `ln -sf "$REPO/{skill-name}" "$HOME/.claude/skills/{skill-name}"`.

## Problem: User invokes "/pm" with a specific intent that matches a skill directly
**Cause:** The user says "/pm create a brief" — the intent maps directly to `create-brief`.
**Solution:** Recommend the specific skill and the trigger phrase. Do not attempt to execute the skill's logic — the router only navigates.
