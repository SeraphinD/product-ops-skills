# RETRO.md Template

Structure for the retrospective artifact produced by `feature-retrospective`.

---

## Full Template

```markdown
# Feature Retrospective: {Feature Name}

> Generated from: docs/features/{feature-name}/
> Date: {YYYY-MM-DD}
> Mode: {Full Retrospective | Checkpoint}
> Pipeline artifacts found: {comma-separated list of artifacts loaded}

---

## Success Criteria Evaluation

| # | Criterion | Verdict | Evidence |
|---|-----------|---------|----------|
| 1 | {criterion text from BRIEF.md} | PASS / FAIL / PARTIAL / UNTESTABLE | {specific task, AC scenario, or artifact reference} |
| 2 | {criterion text} | {verdict} | {evidence} |

**Score: {N}/{M} criteria met ({%})**

{If checkpoint mode: "Note: This is a checkpoint evaluation. Verdicts marked PROJECTED indicate criteria that would pass if remaining tasks are completed."}

---

## Acceptance Criteria Coverage

| Story | Priority | Scenario | Task | Status |
|-------|----------|----------|------|--------|
| US1 — {title} | MUST | Scenario 1: {name} | Task {N}: {title} | ✅ completed |
| US1 — {title} | MUST | Scenario 2: {name} | — | ⚠️ No task |
| US2 — {title} | SHOULD | Scenario 1: {name} | Task {N}: {title} | ⬜ pending |

**Coverage: {N}/{M} scenarios have corresponding tasks ({%})**
**Completion: {N}/{M} covered scenarios have completed tasks ({%})**

---

## Metrics

| Metric | Value | Source |
|--------|-------|--------|
| Task completion rate | {N}% ({completed}/{total}) | TASKS.md |
| Blocked tasks | {N} | TASKS.md |
| Top blocking reason | {reason} ({count} tasks) | TASKS.md |
| Rollback decisions | {N} | DECISION.md |
| Total decisions logged | {N} | DECISION.md |
| WON'T stories (scope excluded) | {N} | SPEC.md |
| AC coverage (scenarios with tasks) | {N}% ({covered}/{total}) | SPEC.md + TASKS.md |
| Effort estimate (OPPORTUNITY) | {N} person-weeks | OPPORTUNITY.md |
| Actual task count | {N} | TASKS.md |

{Skip rows whose source artifact was not found.}

---

## What Went Well

- {Specific positive observation with artifact reference}
- {e.g., "All 8 MUST story scenarios were completed without blocks"}
- {e.g., "No rollback decisions — pipeline ran clean from BRIEF to TASKS"}
- {e.g., "BENCHMARK validated the API design assumptions from the BRIEF"}

---

## What Didn't Go Well

- {Specific problem with artifact reference and impact}
- {e.g., "SPEC didn't define webhook payload format, blocking 3 tasks (Tasks 7, 9, 11)"}
- {e.g., "4 rollback decisions, all from SPEC → BRIEF — scope was underspecified"}
- {e.g., "2 SHOULD stories became WON'T mid-pipeline due to effort underestimation"}

---

## Lessons Learned

- {Actionable, specific improvement for next pipeline run}
- {e.g., "Run validate-coverage.sh after BRIEF→SPEC transition to catch scope gaps early"}
- {e.g., "Include error handling scenarios in BRIEF scope section — omission caused 3 downstream blocks"}
- {e.g., "RICE Effort score of 3 underestimated actual work (15 tasks). Consider breaking features with >10 tasks into sub-features"}

---

## Open Risks

- {Unresolved risk from BRIEF Assumptions & Risks}
- {e.g., "Assumption: 'Third-party API supports batch operations' — never validated, carried forward from BRIEF"}
- {e.g., "Blocked task 'Configure CDN' — requires infrastructure team approval, still pending"}
- {e.g., "AC Scenario 'Given concurrent users > 1000' marked UNTESTABLE — needs load testing in production"}
```

---

## Mode-Specific Adjustments

### Checkpoint Mode

- Replace PASS/FAIL with PROJECTED for criteria whose tasks are still pending
- Add a "Remaining Work" section before Metrics:

```markdown
## Remaining Work

| Status | Count | Tasks |
|--------|-------|-------|
| ⬜ Pending | {N} | {task titles} |
| 🔄 In Progress | {N} | {task titles} |
| ❌ Blocked | {N} | {task titles with block reasons} |
```

### Minimal Retro (few artifacts available)

If only BRIEF.md and TASKS.md exist (no SPEC, no DECISION), simplify:
- Skip Acceptance Criteria Coverage (no SPEC)
- Skip rollback metrics (no DECISION.md)
- Note in header: "Limited artifacts — some sections omitted"
