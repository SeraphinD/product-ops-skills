---
name: pm
description: Product management router — a single entry point to the entire feature pipeline. Scans existing artifacts, detects where you are in the pipeline, and recommends the next skill to invoke. Trigger on "/pm", "pm", "start the pipeline", "what skills are available", "what should I do next", "guide me through the pipeline", "help me build a feature", "product ops", "feature pipeline", or "where am I in the pipeline". Do NOT use for directly invoking a specific pipeline skill when you already know which one you need (e.g., if the user says "create a brief", trigger create-brief directly). This skill is the navigator, not a replacement for the individual skills.
allowed-tools: "Read Glob"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [router, pipeline, orchestrator, entry-point, product-ops]
---

# PM Router Skill

This skill is the single entry point to the Product Ops pipeline. It analyzes context — what the user said, what artifacts already exist — and recommends the right skill to invoke next. It does not produce a document; it navigates.

---

## Pipeline Overview

Present this pipeline when the user needs orientation:

```
[PROBLEM FRAME] → BRIEF → [BENCHMARK] → [OPPORTUNITY] → SPEC → [DESIGN] → PLAN → TASKS
```

| Stage | Skill | Produces | Required? |
|-------|-------|----------|-----------|
| 1 | `create-problem-frame` | `PROBLEM-FRAME.md` | Optional |
| 2 | `create-brief` | `BRIEF.md` | Yes |
| 3 | `brief-to-benchmark` | `BENCHMARK.md` | Optional |
| 4 | `brief-to-opportunity` | `OPPORTUNITY.md` | Optional |
| 5 | `brief-to-specs` | `SPEC.md` | Yes |
| 6a | `spec-to-design` | `DESIGN.md` (web) | Optional |
| 6b | `spec-to-mobile-design` | `DESIGN.md` (mobile) | Optional |
| 7 | `spec-to-plan` | `PLAN.md` | Yes |
| 8 | `plan-to-tasks` | `TASKS.md` | Yes |

---

## Step-by-Step Process

### Step 1 — Determine the Feature

Check whether the user mentioned a feature name or context clues. If ambiguous, scan for existing feature directories:

```
docs/features/*/
```

- If **one feature directory exists**, assume it's the active feature.
- If **multiple directories exist**, list them and ask which one.
- If **no directories exist**, the user is starting fresh — go to Step 3.
- If the user explicitly names a feature, use that.

### Step 2 — Scan Existing Artifacts

Once the feature is identified, scan `docs/features/{feature-name}/` for these files:

| File | Means |
|------|-------|
| `PROBLEM-FRAME.md` | Problem framed |
| `BRIEF.md` | Brief written |
| `BENCHMARK.md` | Benchmark done |
| `OPPORTUNITY.md` | Opportunity scored |
| `SPEC.md` | Spec generated |
| `DESIGN.md` | Design done |
| `PLAN.md` | Plan generated |
| `TASKS.md` | Tasks generated |
| `DECISION.md` | Decisions logged |

Report what exists in a concise status summary:

> **Feature: `{feature-name}`**
>
> | Document | Status |
> |----------|--------|
> | PROBLEM-FRAME.md | ✅ exists / — |
> | BRIEF.md | ✅ exists / — |
> | ... | ... |

### Step 3 — Determine Intent and Recommend

Based on what the user said and what artifacts exist, recommend the next action. Follow this routing logic:

**If the user expressed a specific intent:**

| User Intent | Route To |
|-------------|----------|
| "I have an idea" / "new feature" / "start fresh" | `create-problem-frame` (or `create-brief` if problem is clear) |
| "frame the problem" / "what problem are we solving" | `create-problem-frame` |
| "create a brief" / "write a brief" | `create-brief` |
| "benchmark" / "competitive analysis" / "research" | `brief-to-benchmark` |
| "score this" / "prioritize" / "RICE" | `brief-to-opportunity` |
| "generate specs" / "user stories" / "acceptance criteria" | `brief-to-specs` |
| "design the feature" / "UI design" / "wireframes" | `spec-to-design` or `spec-to-mobile-design` |
| "generate a plan" / "implementation plan" | `spec-to-plan` |
| "generate tasks" / "task list" / "what do I build" | `plan-to-tasks` |

**If the user wants guidance (no specific intent):**

Determine the next logical step based on existing artifacts:

1. Nothing exists → recommend `create-problem-frame` or `create-brief`
2. `PROBLEM-FRAME.md` exists, no `BRIEF.md` → recommend `create-brief`
3. `BRIEF.md` exists, no `SPEC.md` → recommend `brief-to-specs` (mention `brief-to-benchmark` and `brief-to-opportunity` as optional steps)
4. `SPEC.md` exists, no `PLAN.md` → recommend `spec-to-plan` (mention `spec-to-design` as optional step)
5. `PLAN.md` exists, no `TASKS.md` → recommend `plan-to-tasks`
6. `TASKS.md` exists → pipeline is complete; mention they can review or update any artifact

### Step 4 — Present the Recommendation

Format the recommendation clearly:

> **Next step: `{skill-name}`**
>
> {One sentence explaining why this is the next step.}
>
> To proceed, say: *"{exact trigger phrase}"*

If there are optional steps the user could take before the recommended step, mention them:

> **Optional before this step:**
> - `{skill-name}` — {one-line reason}. Say: *"{trigger phrase}"*

### Step 5 — Full Pipeline Mode

If the user asks to "run the full pipeline" or "guide me through everything," present the full sequence and start with the first applicable step:

1. List all steps in order, marking completed ones.
2. Recommend the first incomplete step.
3. After the user completes each step and returns, scan artifacts again and recommend the next step.

---

## Rules

1. **Never produce a document** — this skill only navigates. It does not generate BRIEF.md, SPEC.md, or any pipeline artifact.
2. **Never duplicate skill logic** — do not attempt to replicate what individual skills do. Always direct the user to invoke the appropriate skill.
3. **Scan before recommending** — always check existing artifacts before suggesting a step. Never recommend generating a SPEC if no BRIEF exists.
4. **Respect pipeline order** — required artifacts must exist before their downstream skill can run. `BRIEF.md` must exist before `brief-to-specs`. `SPEC.md` must exist before `spec-to-plan`. `PLAN.md` must exist before `plan-to-tasks`.
5. **Surface optional steps without forcing them** — always mention optional stages (benchmark, opportunity, design) but make it clear they can be skipped.
6. **One recommendation at a time** — do not overwhelm the user with the full pipeline if they only asked "what's next."
7. **English always** — communicate in English regardless of conversation language.

---

## Examples

### Example 1: User starts fresh

User says: "/pm"

Actions:
1. Scan `docs/features/` — no directories found
2. No specific intent detected
3. Recommend starting with `create-problem-frame` or `create-brief`
4. Present:

> No feature in progress. To start a new feature:
>
> **Recommended: `create-problem-frame`** — frame the problem before jumping to solutions.
> Say: *"Frame the problem around {your topic}"*
>
> **Or skip to: `create-brief`** — if the problem is already well-understood.
> Say: *"Create a brief for {your feature}"*

### Example 2: User has a brief, asks what's next

User says: "/pm" (feature directory has BRIEF.md and DECISION.md)

Actions:
1. Scan `docs/features/push-notifications/` — found `BRIEF.md`, `DECISION.md`
2. No SPEC.md exists → next required step is `brief-to-specs`
3. Present status summary and recommendation:

> **Feature: `push-notifications`**
>
> | Document | Status |
> |----------|--------|
> | BRIEF.md | ✅ |
> | SPEC.md | — |
> | PLAN.md | — |
> | TASKS.md | — |
>
> **Next step: `brief-to-specs`** — generate user stories and acceptance criteria from your brief.
> Say: *"Generate specs from the brief"*
>
> **Optional before this step:**
> - `brief-to-benchmark` — research competitors and standards. Say: *"Benchmark the brief"*
> - `brief-to-opportunity` — score this feature with RICE. Say: *"Score this brief"*

### Example 3: Pipeline is complete

User says: "/pm" (feature directory has all artifacts)

Actions:
1. Scan `docs/features/dashboard/` — all files present
2. Pipeline is complete
3. Present:

> **Feature: `dashboard`** — pipeline complete.
>
> | Document | Status |
> |----------|--------|
> | BRIEF.md | ✅ |
> | SPEC.md | ✅ |
> | DESIGN.md | ✅ |
> | PLAN.md | ✅ |
> | TASKS.md | ✅ |
>
> All pipeline stages are done. You can:
> - Review or update any artifact by opening it directly
> - Re-run a stage if requirements changed (the downstream artifacts should be regenerated)
> - Start a new feature: say *"Create a brief for {new feature}"*

### Example 4: User has a specific intent

User says: "/pm I need to score my feature before writing specs"

Actions:
1. Detect intent: "score" → `brief-to-opportunity`
2. Verify prerequisite: scan for `BRIEF.md` — found
3. Present:

> **Next step: `brief-to-opportunity`** — BRIEF.md found, ready to score.
> Say: *"Score this brief"*

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
