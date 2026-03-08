---
name: plan-to-tasks
description: Transforms a PLAN.md into a TASKS.md — a flat, atomic task checklist where every action is traceable to a plan phase and step, has a status (pending/in-progress/completed/blocked), and is optionally assigned to an installed skill. Trigger on phrases like "generate tasks", "create TASKS.md", "tasks from plan", "plan to tasks", "convert plan to tasks", "make a task list from the plan", "extract tasks from plan", "turn the plan into tasks", or when the user has a PLAN.md and wants an actionable, trackable task list — even if they don't say "TASKS.md" explicitly. Do NOT use for generating a plan from specs (use spec-to-plan), generating specs from a brief (use brief-to-specs), or for executing tasks — this skill only produces the task list document.
allowed-tools: "Read Write Glob"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [tasks, task-list, tracking, execution, assignment]
---

# PLAN → TASKS Skill

This skill transforms a `PLAN.md` (or any structured implementation plan) into a `TASKS.md` — a flat, atomic task list where every action is traceable to a phase and step in the plan, has a clear status, and is optionally assigned to a skill or agent best suited to execute it.

## Output Template

**Before writing any output, read `references/template.md` for the exact TASKS.md structure.**

The TASKS document contains: a header with generation metadata and status counts, Phase-grouped tasks (each with Status, Description, PLAN Reference, Skill/Agent assignment, and Notes), and a Summary table.

**After writing, run `bash scripts/validate-tasks.sh {path-to-tasks}` to verify structural completeness.**

---

## Status Values

| Symbol | Meaning |
|--------|---------|
| ⬜ | pending — not yet started |
| 🔄 | in_progress — currently being worked on |
| ✅ | completed {YYYY-MM-DD} — done, with date |
| ❌ | blocked — cannot proceed, reason in Notes |

---

## Skill/Agent Assignment Guide

Skill assignment is **optional**. Only assign a skill when a task clearly maps to an installed skill. If no skill fits, **omit the Skill/Agent field entirely** — Claude Code will execute the task using its built-in tools. For tasks that require human action (e.g., infrastructure decisions, manual deployments), note it in the task description instead.

When a task does map to a known skill, use these conventions:

| Task Nature | Skill/Agent |
|-------------|-------------|
| Build UI components or pages | `frontend-design` |
| Integrate or call an AI/Claude API | `claude-developer-platform` |
| Generate a specification from a brief | `brief-to-specs` |
| Generate a plan from a spec | `spec-to-plan` |

> **Note:** This table is not exhaustive. If the user has other skills installed, assign them when relevant. If unsure whether a skill exists, omit the field — it's better to leave it blank than to reference a non-existent skill.

---

## Interaction Protocol

Work phase by phase. For each phase:
1. Share the tasks you've parsed from the plan
2. Propose a draft of the phase's task entries
3. Ask for confirmation or adjustments before moving on
4. Never skip a phase — if a task's scope or assignment is unclear, ask a targeted question

**Never generate the full TASKS list in one shot without confirming each phase's tasks** with the user first.

---

## Step-by-Step Process

### Step 1 — Locate the PLAN

Find the plan file. Look in this order:
1. The path the user provides directly
2. `docs/features/*/PLAN.md` matching any feature mentioned in context
3. Any `PLAN.md` in the current working directory

Read the file in full. If no plan is found or the path is ambiguous, ask:

> "Which plan file should I use? I didn't find a PLAN.md in the current directory."

If the PLAN references a `DESIGN.md` (visible in its Implementation Details or Project Structure), optionally read the `DESIGN.md` from the same feature directory for additional context when writing task descriptions — particularly for component implementation tasks where the DESIGN.md specifies states, variants, and accessibility requirements that should appear in the task description.

### Step 2 — Load Prior Decisions

Before generating anything, check whether a `DECISION.md` exists in the same `docs/features/{feature-name}/` directory as the PLAN.

If it exists, read it in full. Then:
- **Treat every ✅ Accepted decision as a hard constraint** — do not re-open, re-ask, or contradict it.
- If a prior decision directly conflicts with something in the PLAN, flag the conflict to the user before proceeding: *"Decision {N} says X, but the plan says Y. Which should take precedence?"*
- Do not log prior decisions again — only log new decisions made during this skill's execution.

---

### Step 3 — Parse the Plan Structure

Identify every phase and every numbered step within each phase. For each step, determine:
- Is it an **atomic action** (a single file to create, a single function to implement)?
- Or is it a **broad category** (e.g., "set up the project") that implies multiple sub-tasks?

If a step is too broad to be a single task, ask:

> "Step {N} in Phase {X} — '{step text}' — looks broad. Should I break it into sub-tasks? If so, can you tell me the specific actions it covers?"

Only break a step into sub-tasks when you have enough context to name the sub-tasks precisely. Never invent sub-tasks — invented sub-tasks create false traceability that looks complete but may miss real implementation actions, or include work never intended in the plan.

---

### Step 4 — Clarify Gaps Before Writing

After parsing, before generating anything, scan for information needed to produce a complete, unambiguous task list:

- **Skill assignment** — Are there tasks that clearly map to an installed skill? For tasks that don't, the Skill/Agent field will be omitted.
- **Dependencies** — Are there tasks that can only start after another task is complete? Should dependency links be added?
- **Output path** — Where should `TASKS.md` be written? Default: same directory as the source PLAN.

If any are ambiguous, **ask all clarifying questions in a single message**, grouped by category, with a proposed default for each:

> **Before I generate the task list, I have a few questions:**
>
> **Skill assignment** — Task "Deploy to production" in Phase 3 doesn't map to any installed skill, so I'll omit the Skill/Agent field for it. Tasks like "Build dashboard component" will be assigned to `frontend-design`. OK?
>
> **Dependencies** — Task "Write tests" depends on "Create core module". Should I add a `Depends on:` line to make that explicit?
>
> **Output** — I'll write `TASKS.md` to `docs/features/my-feature/TASKS.md` (same folder as the PLAN). Does that work?
>
> Let me know if anything needs adjusting.

If everything is clear, skip straight to Step 5.

---

### Step 5 — Generate the Task List

For **every** action item in the plan, create exactly one task entry. Rules:

1. **One task per action** — if the plan step says "Create X and configure Y", split it into two tasks. A task with two verbs is a task that can only be half-completed.
2. **Title must be imperative and specific** — "Create `app/routes.py` — API route definitions", not "Add routes". Vague titles cause context-switching and force the implementor to re-read the plan to know what to do.
3. **Description must explain the what and why** — reference the plan's intent, not just the file name. This lets someone execute a task days or weeks later without needing to re-read the full plan.
4. **PLAN Reference must be exact** — include the relative file path, phase number, and step number (e.g., `PLAN.md Phase 2, Step 3`). Exact references are what allows reviewers to catch scope creep and trace every task back to an agreed plan.
5. **Skill/Agent is optional** — only include it when the task clearly maps to an installed skill from the assignment guide. Omit the field entirely when no skill fits.
6. **Notes must name dependencies** — if Task B requires Task A to be done first, write "Depends on: [task title]". Unnamed dependencies are the most common cause of blocked tasks mid-execution.

All tasks start with status `⬜ pending` unless the user has indicated otherwise.

---

### Step 6 — Final Review & Confirm

Once all phases have been confirmed individually, show the complete `TASKS.md` content to the user for a final review:

> Here's the full `TASKS.md` — **{N} tasks** across **{P} phases** from `{PLAN path}`.
>
> Ready to write it to `{output path}`?

Wait for the user to confirm before writing the file.

---

### Step 7 — Determine Output Path

`TASKS.md` is written to the **same directory as the source PLAN** by default.

**Resolution logic:**
1. If the PLAN is at `docs/features/my-feature/PLAN.md`, write to `docs/features/my-feature/TASKS.md`.
2. If the PLAN is in the current working directory root, write `TASKS.md` to the root.
3. If a `TASKS.md` already exists at that path, ask the user before overwriting.
4. If the user specifies a different path, use it.

---

### Step 8 — Write the File

1. Assemble the complete `TASKS.md` using the template above.
2. Write the file using the Write tool.
3. Confirm to the user: *"Done — `TASKS.md` written to `{path}` with {N} tasks."*

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Explicit decisions** — choices the user made when you asked a clarifying question (e.g., task granularity, skill assignment, dependency links)
- **Implicit decisions** — choices you made without asking because the plan was clear enough (e.g., assigning a skill to a task, deciding a step is atomic vs. needs splitting, omitting skill assignment for a task)
- **Functional decisions** — choices about task scope or ordering that affect how the feature gets built (e.g., choosing to split a broad step into sub-tasks, deciding two tasks have no dependency)

### What NOT to log

- Obvious, mechanical actions (e.g., "wrote the file", "set status to pending")
- Formatting or template-structure decisions already defined by the skill

### Entry format

Each decision follows this structure:

```markdown
## Decision {N}: {Short title}
**Status:** ✅ Accepted
**Date:** {YYYY-MM-DD}
**Skill:** plan-to-tasks

### Context
{1–2 sentences: what was being decided and why}

### Problem
{The question that needed answering}

### Options Considered
| Option | Pros | Cons |
|--------|------|------|
| **{Chosen}** | {pros} | {cons} |
| {Alternative} | {pros} | {cons} |

### Decision
**{One-sentence statement of the decision}**

### Rationale
{Numbered list of reasons}

### Consequences
- **Positive:** {impact}
- **Negative:** {impact}
- **Neutral:** {impact}

### Exceptions
{Any exceptions, or "None"}
```

> For simple decisions (e.g., confirming a skill assignment), keep the entry lightweight — skip Options Considered and Consequences if they add no value. Use the full format for decisions that affect task structure or execution order.

### When to write

Append decisions to `DECISION.md` as they happen during the interaction — do not batch them at the end. This ensures the log is complete even if the session is interrupted.

---

## Rules

1. **Complete coverage** — every action in the plan must become a task. Do not omit or merge steps.
2. **Atomic tasks** — each task must be completable independently. If a step is too broad, break it or ask.
3. **Traceable** — every task must reference the exact PLAN phase and step it comes from. No invented tasks.
4. **Skill assignment is optional** — only assign a skill when the task clearly maps to an installed skill. Omit the Skill/Agent field when no skill fits. Never reference a skill that may not exist.
5. **English always** — write `TASKS.md` in English regardless of the language used in the conversation.
6. **Interactive and thorough** — ask all clarifying questions at once, grouped, with proposed defaults. Then propose each phase's tasks as a draft and confirm with the user before moving on. Do not generate the full task list in one shot without phase-by-phase confirmation.
7. **Confirm before writing** — always show the task count summary and ask for confirmation before writing the file.
8. **No filler** — do not add tasks for things not in the plan. Do not add generic best-practice tasks.

---

## Examples

### Example 1: Small feature with 3 phases
User says: "Generate tasks from the greeting tool plan"
Actions:
1. Locate `docs/features/greeting-tool/PLAN.md` — 3 phases (MUST, Testing, Docs)
2. Parse 5 implementation steps → 5 atomic tasks
3. No tasks map to installed skills — Skill/Agent field omitted on all tasks
4. Add dependency notes: "Write tests" depends on "Create core module"
5. Write to `docs/features/greeting-tool/TASKS.md`
Result: A TASKS.md with 5 tasks, all `pending`, no skill assignments needed

### Example 2: Large feature with DESIGN.md references
User says: "Turn the dashboard plan into tasks"
Actions:
1. Locate PLAN — 5 phases, 18 steps. Load DESIGN.md for component details
2. Parse each step — break 2 broad steps into sub-tasks after asking the user
3. Generate 22 atomic tasks with specific descriptions referencing DESIGN.md specs
4. Assign `frontend-design` to UI component tasks; omit Skill/Agent for logic, testing, and infrastructure tasks
5. Write to `docs/features/analytics-dashboard/TASKS.md`
Result: A TASKS.md with 22 tasks across 5 phases, skill assigned only where relevant

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
