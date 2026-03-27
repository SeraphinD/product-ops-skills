---
name: feature-retrospective
description: Reviews a completed (or in-progress) feature by comparing outcomes against the original BRIEF success criteria and SPEC acceptance criteria, computing quantitative metrics (task completion rate, blocked count, scope changes), and producing a structured RETRO.md with process review and lessons learned. Trigger on phrases like "retrospective", "retro", "feature review", "how did we do", "review completed work", "sprint review", "evaluate the feature", "success criteria check", or when the user has completed tasks and wants to assess outcomes. Do NOT use for executing tasks (use execute-tasks), generating tasks (use plan-to-tasks), or any upstream pipeline step.
allowed-tools: "Read Write Glob Grep"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [retrospective, review, metrics, success-criteria, process-improvement]
---

# Feature Retrospective Skill

This skill reviews a completed (or in-progress) feature by reading all pipeline artifacts, evaluating outcomes against success criteria, computing quantitative metrics, and producing a structured `RETRO.md`.

This is the **optional final stage** of the feature pipeline:

```
BRIEF → SPEC → PLAN → TASKS → [EXECUTION] → [RETRO]
```

Its purpose is to close the feedback loop — answering "Did we build what we set out to build?" and "What should we do differently next time?"

**Artifact produced:** `docs/features/{feature-name}/RETRO.md`

---

## Retro Modes

The skill adapts based on pipeline completion state:

| Mode | Condition | Behavior |
|------|-----------|----------|
| **Full Retrospective** | All tasks completed (or all tasks completed/blocked with none pending) | Comprehensive review with final verdicts |
| **Checkpoint** | Some tasks still pending or in-progress | Progress snapshot with projections and partial assessments |

The skill detects the mode automatically from TASKS.md. If no TASKS.md exists, it runs as a checkpoint based on whatever artifacts are available.

---

## Step-by-Step Process

### Step 1 — Locate the Feature Directory

Find the feature's artifact directory. Look in this order:
1. The path the user provides directly
2. `docs/features/*/` matching any feature mentioned in context
3. Any directory in the current working directory containing a `BRIEF.md`

If no feature directory is found, ask:
> "Which feature should I review? I didn't find a feature directory with pipeline artifacts."

---

### Step 2 — Load All Pipeline Artifacts

Read all available artifacts from `docs/features/{feature-name}/`:

| Artifact | Required? | Purpose |
|----------|-----------|---------|
| `BRIEF.md` | **Required** | Success criteria, objectives, assumptions, risks |
| `SPEC.md` | Recommended | Acceptance criteria, user stories, MoSCoW priorities |
| `TASKS.md` | Recommended | Task statuses, completion data, blocked tasks |
| `BENCHMARK.md` | Optional | Competitive context, validated/invalidated assumptions |
| `OPPORTUNITY.md` | Optional | Original effort estimates for comparison |
| `DESIGN.md` | Optional | Component scope for design coverage check |
| `PLAN.md` | Optional | Phase structure for process review |
| `DECISION.md` | Optional | Decision history, rollback count |
| `GDPR-REVIEW.md` | Optional | GDPR compliance requirements and acceptance criteria |
| `ACCESSIBILITY-REVIEW.md` | Optional | Accessibility compliance requirements and acceptance criteria |
| `AI-ACT-REVIEW.md` | Optional | AI Act compliance requirements and acceptance criteria |

Report what was found:
> "Loaded {N} artifacts for `{feature-name}`: {list of found artifacts}"
>
> {If BRIEF.md missing: "BRIEF.md is required for success criteria evaluation. Please provide its location or I'll skip that section."}

---

### Step 3 — Determine Retro Mode

Parse TASKS.md (if available) to determine mode:

- Count tasks by status: pending, in-progress, completed, blocked
- **Full Retrospective** if: no pending or in-progress tasks (all completed or blocked)
- **Checkpoint** if: any pending or in-progress tasks remain

Announce the mode:
> "Running **{mode}** retrospective. TASKS.md shows {N} completed, {N} pending, {N} blocked out of {total}."

---

### Step 4 — Success Criteria Evaluation

For each criterion in BRIEF.md's Success Criteria section:

1. **Identify the criterion** — extract the text from the `[x]` or `[ ]` checklist
2. **Trace to SPEC** — find the acceptance criteria (Given/When/Then scenarios) that map to this criterion
3. **Trace to TASKS.md** — find the tasks that implement those acceptance criteria
4. **Assess verdict:**

| Verdict | Meaning | Condition |
|---------|---------|-----------|
| PASS | Criterion met | All mapped tasks completed, AC scenarios covered |
| FAIL | Criterion not met | Mapped tasks incomplete or absent, no evidence of delivery |
| PARTIAL | Partially met | Some mapped tasks completed, others pending/blocked |
| UNTESTABLE | Cannot verify from artifacts | No AC coverage, or criterion requires production data/user feedback |

5. **Provide evidence** — reference the specific tasks, AC scenarios, or artifact sections that support the verdict

Present as a table for user review before assembling into RETRO.md.

---

### Step 5 — Acceptance Criteria Coverage

For each user story in SPEC.md:

1. List every Given/When/Then scenario
2. Check if a corresponding task exists in TASKS.md
3. Check the task's status

Flag any scenarios with **no task coverage** — these represent specification gaps that were never planned for execution.

Present as a table:
> | Story | Scenario | Task | Status |
> |-------|----------|------|--------|
> | US1 — MUST | Scenario 1: Happy path | Task 3: Create auth endpoint | ✅ completed |
> | US1 — MUST | Scenario 2: Invalid credentials | — | ⚠️ No task |

---

### Step 6 — Quantitative Metrics

Compute from artifacts:

**From TASKS.md:**
- **Task completion rate:** completed / total (%)
- **Blocked task count** and top blocking reasons (from Notes fields)
- **In-progress tasks** (for checkpoint mode)

**From SPEC.md:**
- **Scope changes:** count of WON'T stories, any stories that were MUST and became WON'T
- **AC coverage:** scenarios with tasks / total scenarios (%)

**From DECISION.md (if available):**
- **Decision count:** total decisions logged
- **Rollback count:** decisions with Type: Rollback
- **Pipeline stage durations:** if decisions have dates, compute first-to-last date per skill

**From OPPORTUNITY.md (if available):**
- **Effort estimate vs actual:** original Effort score vs actual task count

Present all metrics in a table. Skip any metric whose source artifact is missing.

---

### Step 7 — Process Review: What Went Well

Identify positives from the artifact trail:

- **Clean pipeline stages** — skills that produced artifacts with no rollback decisions in DECISION.md
- **Tasks without blocks** — count of tasks that went straight from pending to completed
- **Validated assumptions** — BRIEF assumptions confirmed by BENCHMARK data or task outcomes
- **Scope stability** — low WON'T count, no MoSCoW priority changes mid-pipeline
- **Fast skill iterations** — stages completed in single sessions (if date data available)

Present as bullets. Base every claim on artifact evidence.

---

### Step 8 — Process Review: What Didn't Go Well

Identify pain points from the artifact trail:

- **Rollback decisions** — count and summarize each rollback from DECISION.md
- **Blocked tasks** — list with root causes grouped by category (dependency, upstream, external, technical)
- **AC gaps** — acceptance criteria with no task coverage (from Step 5)
- **Ambiguities** — flags or questions logged during SPEC or PLAN generation
- **Invalidated assumptions** — BRIEF assumptions contradicted by BENCHMARK or task outcomes
- **Scope creep indicators** — tasks that appeared during execution but weren't in the original PLAN

Present as bullets with references to specific artifacts and entries.

---

### Step 9 — Lessons Learned and Open Risks

Synthesize actionable insights:

**Lessons Learned:**
- What should be done differently in the next pipeline run?
- Which pipeline stage caused the most rework and why?
- Were the right skills used for the right tasks?

**Compliance Review Evaluation:**
If any compliance review artifacts (`GDPR-REVIEW.md`, `ACCESSIBILITY-REVIEW.md`, `AI-ACT-REVIEW.md`) were loaded in Step 2, evaluate their findings:
- Cross-reference each review's compliance acceptance criteria against completed tasks — were they implemented?
- Flag any compliance requirements that were identified in a review but never made it into the SPEC, PLAN, or TASKS
- Note which compliance reviews were run and which were skipped despite being relevant (e.g., feature handles personal data but no GDPR review was run)

**Open Risks:**
- BRIEF Assumptions & Risks that were never resolved or tested
- Benchmark claims that were carried forward without verification
- Blocked tasks whose root causes remain unresolved
- Acceptance criteria marked UNTESTABLE that need production validation
- Compliance requirements from review artifacts that were identified but never implemented

Each lesson and risk should be specific and actionable, not generic platitudes.

---

### Step 10 — Assemble and Review

Compile all sections into the RETRO.md structure (see `references/template.md` for the full template).

Present the complete document to the user:
> "Here's the retrospective for `{feature-name}`. Please review — I can adjust any section before writing."

Wait for user confirmation. Handle feedback:
- **Verdict disagreements** — adjust with the user's evidence
- **Missing context** — add details the artifacts don't capture (team dynamics, timeline pressure, etc.)
- **Tone adjustments** — the retro should be objective, not blame-oriented

---

### Step 11 — Write the File

Write to `docs/features/{feature-name}/RETRO.md`.

Confirm:
> "RETRO.md written to `docs/features/{feature-name}/RETRO.md`."
>
> {If full retro: "The feature pipeline is complete. All artifacts: BRIEF → SPEC → PLAN → TASKS → RETRO."}
> {If checkpoint: "This is a checkpoint retro. Run again after all tasks are completed for a full retrospective."}

---

## Decision Logging

Log non-obvious decisions made during the retrospective to `docs/features/{feature-name}/DECISION.md`:

### What to Log

- **Verdict overrides** — when the user disagrees with a PASS/FAIL/PARTIAL assessment and you adjust it
- **Scope interpretation** — when it's ambiguous whether a success criterion is met
- **Risk acceptance** — when the user acknowledges an open risk and decides not to act on it

For entry format, shared exclusions, and writing rules, see `references/decision-log-format.md`.

---

## Rules

1. **BRIEF.md is the source of truth for success criteria** — verdicts come from BRIEF objectives, not from what the team happened to build. A completed task is irrelevant if it doesn't map to a success criterion.
2. **Evidence over opinion** — every verdict (PASS/FAIL/PARTIAL/UNTESTABLE) must reference a specific artifact, task, or AC scenario. No unsupported claims.
3. **Checkpoint retros don't have final verdicts** — use PARTIAL or PROJECTED instead of PASS/FAIL for unfinished features. Projections state what would need to happen for the criterion to pass.
4. **Don't fabricate metrics** — if the source artifact doesn't exist, skip the metric. Don't estimate task counts or durations from incomplete data.
5. **Lessons are specific, not generic** — "communicate better" is not a lesson. "The SPEC didn't define the webhook payload format, which blocked 3 tasks" is a lesson.
6. **English always** — all retro content in English regardless of conversation language.
7. **Non-judgmental tone** — the retro evaluates process and outcomes, not people. Frame problems as systemic, not personal.
8. **Don't modify other artifacts** — this skill reads pipeline artifacts but never changes them. If a BRIEF success criterion seems wrong, note it as a lesson learned, don't edit the BRIEF.

---

## Pipeline Iteration

This skill is the final stage — it has no downstream. However, its findings can trigger upstream revisions for future iterations.

### When This Skill Feeds Back

- **Success criteria were unmeasurable** — flag in lessons learned: *"Criterion '{X}' from the BRIEF was untestable. For future briefs, ensure criteria are verifiable from artifacts alone."*
- **AC scenarios had no task coverage** — flag as a `brief-to-specs` or `plan-to-tasks` improvement: *"{N} AC scenarios were never planned as tasks. The spec-to-plan or plan-to-tasks step should check for full AC coverage."*
- **Rollback pattern detected** — if the same upstream stage caused multiple rollbacks, flag as a systemic issue: *"The SPEC required {N} rollbacks. Consider more thorough BRIEF validation before spec generation."*
- **Effort estimate was far off** — if OPPORTUNITY.md exists and the effort score differs significantly from actual work, note it: *"Original effort estimate was {X}, actual task count suggests {Y}. Calibrate future RICE scoring."*

These findings are captured in RETRO.md, not by modifying upstream artifacts. The user decides whether to act on them in the next pipeline run.

For the universal rollback protocol (should it be needed for corrections during the retro itself), see `references/pipeline-iteration.md`.

---

## Examples

### Example 1: Full retrospective — all tasks completed
User says: "Let's do a retro on the greeting tool"
Actions:
1. Locate `docs/features/greeting-tool/` — found 6 artifacts
2. Load all: BRIEF, SPEC, PLAN, TASKS, DECISION — no BENCHMARK, no OPPORTUNITY
3. Mode: Full Retrospective (12/12 tasks completed)
4. Success Criteria: 3/3 PASS, all mapped to completed tasks
5. AC Coverage: 8/8 scenarios have tasks, all completed
6. Metrics: 100% completion, 0 blocked, 2 decisions (0 rollbacks)
7. What Went Well: clean pipeline, no rollbacks, all ACs covered
8. What Didn't Go Well: no BENCHMARK means competitive assumptions unverified
9. Lessons: "Run benchmark before spec to validate API design assumptions"
10. Assemble → user confirms → write RETRO.md
Result: Complete retrospective documenting a clean pipeline run

### Example 2: Checkpoint retro — mid-execution
User says: "How are we doing on the notification system?"
Actions:
1. Locate `docs/features/notification-system/`
2. Load: BRIEF, SPEC, TASKS — 8/15 tasks completed, 2 blocked, 5 pending
3. Mode: Checkpoint (5 pending tasks)
4. Success Criteria: 1 PASS, 1 PARTIAL (3/5 tasks done), 1 PROJECTED
5. AC Coverage: 12/18 scenarios have completed tasks, 4 have pending tasks, 2 have no tasks
6. Metrics: 53% completion, 2 blocked (both dependency blocks)
7. Present checkpoint retro → user confirms → write RETRO.md
Result: Progress snapshot with projections and gap identification

### Example 3: Retro revealing upstream issues
User says: "Retro on the payment gateway"
Actions:
1. Load all artifacts — DECISION.md shows 4 rollback entries
2. Mode: Full Retrospective (all tasks completed or blocked)
3. Success Criteria: 2/4 PASS, 1 FAIL (tasks blocked, never unblocked), 1 PARTIAL
4. Metrics: 78% completion, 3 blocked (all trace to SPEC gaps)
5. What Didn't Go Well: 4 rollbacks, all from SPEC to BRIEF — BRIEF scope was underspecified
6. Lessons: "The BRIEF's scope section didn't cover error handling. 3 tasks were blocked because the SPEC inherited the gap. Run `validate-coverage.sh` after BRIEF→SPEC to catch this earlier."
7. Assemble → user confirms → write RETRO.md
Result: Retrospective surfacing systemic issues for future pipeline improvement

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
