# Pipeline Iteration Protocol

Shared protocol for handling backward movement in the product ops pipeline. When downstream work reveals that an upstream document needs revision, follow this protocol.

---

## How to Go Back

1. **Never silently modify an upstream document** — always ask the user first. Present the issue, the upstream document affected, and the specific sections that need revision.
2. **Log the rollback decision** to `DECISION.md` using the Rollback Entry format below — full context on what changed, why, and what the original was.
3. **Regenerate only affected sections** — do not rewrite the entire upstream document. Re-open the specific sections interactively with the user.
4. **Re-run the upstream skill's validation script** after changes (e.g., `validate-brief.sh`, `validate-spec.sh`).
5. **Re-run any cross-stage validation** that spans the changed boundary (e.g., `bash scripts/validate-coverage.sh {brief} {spec}` after a BRIEF change that feeds into a SPEC).
6. **Assess downstream impact** — after fixing the upstream document, identify which downstream artifacts are invalidated. Only regenerate those whose content is actually affected by the change.

---

## What NOT to Do

- **Don't modify upstream to match downstream** — the upstream document is the source of truth for intent. If the SPEC contradicts the BRIEF, the BRIEF wins unless the user explicitly decides otherwise.
- **Don't skip the rollback conversation** — silent upstream changes cause downstream drift. Every rollback must be acknowledged by the user.
- **Don't batch rollback decisions** — log each one individually as it happens. Batched rollbacks obscure the reasoning chain.
- **Don't regenerate all downstream artifacts after a minor fix** — a typo in the BRIEF's Problem Statement doesn't invalidate the PLAN's project structure. Only regenerate artifacts whose content is actually affected.
- **Don't re-open settled decisions** — if a prior rollback already addressed an issue and the user confirmed the resolution, don't revisit it unless new information emerges.

---

## Rollback Decision Log Entry

When logging a rollback to `DECISION.md`, use this format:

```markdown
## Decision {N}: Rollback — {Short title}
**Status:** ✅ Accepted
**Date:** {YYYY-MM-DD}
**Skill:** {skill-name}
**Type:** Rollback

### Trigger
{Which downstream artifact or step revealed the problem, and what the problem is}

### Upstream Impact
- **Document:** {upstream document path, e.g., `BRIEF.md`}
- **Sections affected:** {list of sections that need revision}
- **Original value:** {what the upstream document currently says}
- **Revised value:** {what it should say after the fix}

### Downstream Impact
- **Invalidated artifacts:** {list of downstream documents that need regeneration, or "None — change is contained"}
- **Unaffected artifacts:** {list of downstream documents that remain valid despite the upstream change}

### Decision
**{One-sentence statement of what was changed and why}**

### Rationale
{Why the upstream document was wrong and how the downstream work revealed it}
```

> For minor rollbacks (e.g., a missing bullet point, a vague sentence), keep the entry lightweight — skip Downstream Impact if the change is clearly contained. Use the full format for rollbacks that affect multiple downstream artifacts.

---

## Experiment Iteration

When experiment results require changes, follow these protocols in addition to the standard rollback rules above.

### KILL Teardown

When a RETRO verdict is **KILL** (control wins, variant is rejected):

1. Flag to the user which PLAN phases and TASKS are affected — specifically the variant User Stories and experiment infrastructure tasks
2. Propose a cleanup task list: remove variant code paths, remove feature flag configuration, remove variant-specific analytics instrumentation. The control path remains untouched.
3. Log the KILL decision to `DECISION.md` using the Experiment Decision format
4. Do not remove the Experimentation Strategy from the SPEC — it documents what was tested and why it was rejected

### ITERATE Re-entry

When a RETRO verdict is **ITERATE** (inconclusive, hypothesis needs revision):

1. The feedback loop is: RETRO (lesson learned) → BRIEF (refine experiment hypothesis in `### Experiment Criteria`) → SPEC (adjust Experimentation Strategy — new hypothesis, revised metrics or thresholds) → PLAN (update infrastructure if needed) → TASKS (new or modified tasks)
2. Each stage regenerates only experiment-affected sections — do not regenerate the entire document
3. The `EXP-ID` is preserved (e.g., `EXP-feature-1`) to maintain traceability across iterations
4. Log the ITERATE decision with the revised hypothesis in `DECISION.md`

### Retroactive Experiment Addition

When experiment criteria are added to a BRIEF after downstream artifacts (SPEC, PLAN, TASKS) already exist:

1. Treat it as a scope expansion — flag affected SPEC stories that need `### Experimentation Strategy` blocks
2. Add Experimentation Strategy blocks to the relevant User Stories in the SPEC
3. Regenerate the PLAN with an experiment infrastructure sub-phase (or deferral note if no tooling)
4. Regenerate TASKS from the updated PLAN
5. Log as a Rollback decision with Type: Experiment Addition
