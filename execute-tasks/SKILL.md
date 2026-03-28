---
name: execute-tasks
description: Reads a TASKS.md and works through tasks — picking the next actionable item, executing simple tasks directly, delegating complex tasks to assigned skills, updating statuses, and handling blocked tasks. Trigger on phrases like "execute tasks", "start building", "work on tasks", "pick up next task", "run the task list", "execute the plan", "start implementing", or when the user has a TASKS.md and wants to begin or continue implementation. Do NOT use for generating a task list (use plan-to-tasks), generating a plan (use spec-to-plan), or reviewing completed work (use feature-retrospective).
allowed-tools: "Read Write Glob Grep Shell"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [execution, tasks, implementation, orchestrator, tracking]
---

# Execute Tasks Skill

This skill reads a `TASKS.md` and works through tasks one at a time — picking the next actionable item, executing simple tasks directly or delegating complex ones, updating statuses in-place, and handling blocked tasks.

This is the **optional execution phase** of the feature pipeline:

```
BRIEF → SPEC → PLAN → TASKS → [EXECUTION] → [RETRO]
```

Its purpose is to bridge the gap between having a task list and having completed work. Users can skip this phase and execute tasks manually. This skill exists for when they want structured, tracked execution with status updates baked into `TASKS.md`.

**This skill does not produce a new artifact.** It updates `TASKS.md` in-place — changing statuses, adding completion dates, and recording block reasons.

---

## Status Values

The skill reads and writes these status values in `TASKS.md`:

| Symbol | Meaning |
|--------|---------|
| ⬜ | pending — not yet started |
| 🔄 | in_progress — currently being worked on |
| ✅ | completed {YYYY-MM-DD} — done, with date |
| ❌ | blocked — cannot proceed, reason in Notes |

---

## Task Complexity Classification

Before executing any task, classify it:

| Classification | Criteria | Action |
|---|---|---|
| **Simple** | File creation, config change, boilerplate, scaffold, rename | Execute directly using Write/Shell tools |
| **Complex with skill** | Task has a Skill/Agent assignment (e.g., `frontend-design`) | Inform user which skill to invoke and provide task context |
| **Complex without skill** | Multi-file logic, API integration, business rules, no skill assigned | Propose an execution approach, ask user to confirm before proceeding |
| **Human-required** | Infrastructure decisions, manual deploys, external approvals, vendor setup | Flag as requiring human action, skip to next task |

---

## Interaction Protocol

For each task:
1. Present the task (title, description, dependencies, assignment)
2. Classify it and propose the execution approach
3. Ask for confirmation before executing
4. Execute or delegate
5. Verify the outcome
6. Update TASKS.md
7. Ask whether to continue or pause

**Never execute a task without confirming the approach with the user first.**

---

## Step-by-Step Process

### Step 1 — Locate TASKS.md

Find the task list. Look in this order:
1. The path the user provides directly
2. `docs/features/*/TASKS.md` matching any feature mentioned in context
3. Any `TASKS.md` in the current working directory

Read the file in full. If no TASKS.md is found, ask:
> "Which TASKS.md should I work on? I didn't find one in the current directory."

---

### Step 2 — Load Supporting Artifacts

Read the following from the same `docs/features/{feature-name}/` directory for execution context:

- **`SPEC.md`** — acceptance criteria define "done" for each task
- **`DESIGN.md`** — component specs, design tokens, and layout details for frontend tasks
- **`PLAN.md`** — phase context and implementation details
- **`DECISION.md`** — treat all Accepted decisions as hard constraints

Report what was found:
> "Loaded SPEC.md, DESIGN.md, PLAN.md, and DECISION.md for context."

---

### Step 3 — Present Status Dashboard

Parse TASKS.md and show current status:

> **Feature: `{feature-name}` — Execution Status**
>
> | Status | Count |
> |--------|-------|
> | ⬜ Pending | {N} |
> | 🔄 In Progress | {N} |
> | ✅ Completed | {N} |
> | ❌ Blocked | {N} |
> | **Total** | **{N}** |
>
> {If blocked tasks exist: "**Blocked:** {task title} — {reason}"}

---

### Step 4 — Identify Next Actionable Task

Find the next task to work on using this priority:

1. **Resume in-progress tasks first** — if any task has status 🔄, resume it
2. **First pending task with met dependencies** — scan pending tasks top-to-bottom; a task is actionable if all tasks listed in its "Depends on:" note are completed
3. **If all pending tasks have unmet dependencies** — identify the dependency chain and flag it

If no actionable tasks remain (all completed or all blocked), report:
> "No actionable tasks. {N} completed, {N} blocked. Run `feature-retrospective` to review outcomes."

---

### Step 5 — Classify and Propose

For the identified task, classify it per the Complexity Classification table above, then present:

> **Next task: {task title}**
>
> **Description:** {from TASKS.md}
> **Classification:** {Simple / Complex with skill / Complex without skill / Human-required}
> **Approach:** {what you'll do — e.g., "Create the file with the following structure..." or "Delegate to `frontend-design` skill" or "This requires human action — skipping"}
>
> Proceed?

Wait for confirmation. If the user wants to skip this task, mark it as blocked with reason "Skipped by user" and move to the next.

---

### Step 6 — Execute or Delegate

**Simple tasks — execute directly:**
1. Write files using the Write tool
2. Run commands using Shell (e.g., `npm init`, `mkdir`, config changes)
3. Follow DESIGN.md specifications for component scaffolding
4. Follow SPEC.md acceptance criteria as the definition of done

**Complex tasks with skill assignment:**
1. Present the task context (description, relevant SPEC/DESIGN sections)
2. Tell the user which skill to invoke: *"This task is assigned to `{skill}`. Invoke it with: '{trigger phrase}'"*
3. Mark the task as 🔄 in-progress
4. When the user returns after running the skill, verify the outcome and mark completed

**Complex tasks without skill assignment:**
1. Propose a concrete implementation approach
2. After user confirms, execute step by step
3. Show work as you go — don't produce large outputs silently

**Human-required tasks:**
1. Flag: *"This task requires human action: {description}. I'll skip it for now."*
2. Leave status as ⬜ pending (not blocked — the user will handle it outside the pipeline)
3. Move to the next actionable task

---

### Step 7 — Verify and Update TASKS.md

After executing a task:

1. **Verify the outcome** — check that the expected result exists:
   - File created? Read it to confirm
   - Test should pass? Run it
   - Config changed? Verify the value
   - Experiment infrastructure task? Verify: feature flag ON → variant behavior observed, feature flag OFF → control behavior observed, analytics events fire in both states
   - If verification fails, do not mark completed — fix the issue or mark as blocked

2. **Update the task status** in TASKS.md:
   - Change `⬜ pending` to `✅ completed {YYYY-MM-DD}`
   - If the task was in-progress, change `🔄 in_progress` to `✅ completed {YYYY-MM-DD}`

3. **Update the header counts** — recalculate and update the `> Total Tasks: {N} | ⬜ Pending: {N} | ...` line

For the exact update format, see `references/template.md`.

---

### Step 8 — Handle Blocked Tasks

When a task can't proceed:

1. **Dependency block** — a required task isn't completed yet. Check if the blocking task can be done first and propose reordering.
2. **Upstream artifact issue** — the SPEC, DESIGN, or PLAN is missing information needed for this task. Follow `references/pipeline-iteration.md` to flag the upstream gap.
3. **External block** — waiting on an external service, approval, or human decision. Mark as ❌ blocked with reason in Notes.
4. **Technical block** — code error, failing test, incompatible dependency. Attempt to resolve; if unresolvable, mark as blocked with diagnostic details.

When marking a task as blocked, update its Notes field:
```
- **Notes:** ❌ Blocked {YYYY-MM-DD}: {reason}. Depends on: {blocking task or artifact}
```

---

### Step 9 — Continue or Pause

After each task completion or block:

> *"Task '{title}' {completed/blocked}. {N} tasks remaining ({M} pending, {K} blocked). Continue to next task, or pause here?"*

- **Continue** → loop back to Step 4
- **Pause** → confirm TASKS.md is saved with all current statuses, inform the user they can resume later by invoking `execute-tasks` again

---

### Step 10 — Session Summary

When pausing or when all tasks are done, show a session summary:

> **Execution session summary:**
>
> | Action | Count |
> |--------|-------|
> | Tasks completed this session | {N} |
> | Tasks blocked this session | {N} |
> | Tasks skipped (human-required) | {N} |
>
> **TASKS.md status:** {N} completed, {N} pending, {N} blocked out of {total}
>
> {If all completed: "All tasks done. Run `feature-retrospective` to review outcomes against success criteria."}

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Execution approach decisions** — when the user overrides the proposed approach for a task
- **Skip decisions** — when a task is skipped and why
- **Block decisions** — when a task is marked blocked, the root cause, and any attempted resolution
- **Scope decisions** — when a task reveals that additional work is needed not covered by the PLAN

For entry format, shared exclusions, and writing rules, see `references/decision-log-format.md`.

---

## Rules

1. **Never mark completed without verification** — check that the described outcome exists (file created, test passes, config applied). Unverified completions create false progress.
2. **Never execute with unmet dependencies** — if a task depends on another task that isn't completed, flag the dependency gap. Don't silently reorder.
3. **Update TASKS.md after every status change** — not in batch at the end. If the session is interrupted, the file should reflect all work done so far.
4. **Don't replicate skill logic** — for tasks assigned to a specific skill, delegate. Don't attempt to reproduce what `frontend-design` or `brief-to-specs` does.
5. **Confirm before executing** — always present the approach and wait for user approval before writing code or running commands.
6. **English always** — all status updates, block reasons, and session summaries in English regardless of conversation language.
7. **Respect DECISION.md constraints** — treat all Accepted decisions as hard constraints during execution.
8. **Simple tasks stay simple** — if a "simple" task turns out to be complex during execution (unexpected dependencies, missing context), stop, reclassify, and ask the user how to proceed.

---

## Pipeline Iteration

Sometimes execution reveals that an upstream document needs revision. This section defines when to go back and how.

### When to Go Back

- **A task references a SPEC acceptance criterion that is ambiguous or untestable** — the definition of "done" is unclear. Flag it: *"Task '{title}' can't be verified because the SPEC's AC is ambiguous: {quote}. Should I update the SPEC first?"*
- **A task requires DESIGN.md details that don't exist** — a component needs states, tokens, or layout specs not covered in the design. Flag it: *"This task needs design details for {component} that DESIGN.md doesn't cover. Should I update the DESIGN first?"*
- **A task's described outcome contradicts a DECISION.md constraint** — the PLAN step and a prior decision are in conflict. Flag it: *"Decision {N} says {X}, but this task requires {Y}. Which takes precedence?"*
- **Multiple tasks are blocked by the same upstream gap** — a pattern of blocks indicates a systemic issue in the SPEC or PLAN. Escalate: *"{N} tasks are blocked because the SPEC doesn't cover {topic}. This needs an upstream fix."*

For the universal rollback protocol (how to go back, what not to do, decision log format), see `references/pipeline-iteration.md`.

---

## Examples

### Example 1: Simple task — direct execution
User says: "Execute tasks for the greeting tool"
Actions:
1. Locate `docs/features/greeting-tool/TASKS.md` — 5 tasks, all pending
2. Load SPEC.md, PLAN.md — no DESIGN.md
3. Dashboard: 5 pending, 0 completed, 0 blocked
4. Next task: "Create `app/__main__.py` — CLI entry point"
5. Classify: Simple (file creation)
6. Propose: "I'll create `app/__main__.py` with argparse setup per SPEC"
7. User confirms → write the file → verify it exists → mark completed
8. Update TASKS.md: 4 pending, 1 completed
Result: One task completed, TASKS.md updated in-place

### Example 2: Complex task — delegate to skill
User says: "Pick up next task"
Actions:
1. Resume from TASKS.md — 3 pending, 2 completed
2. Next task: "Create NotificationCard component" — Skill/Agent: `frontend-design`
3. Classify: Complex with skill assignment
4. Present: "This task is assigned to `frontend-design`. Invoke it with: 'Build the NotificationCard component from the design spec'"
5. Mark as in-progress
6. User runs the skill, returns → verify component file exists → mark completed
Result: Task delegated and tracked

### Example 3: Blocked task — upstream issue
User says: "Continue executing"
Actions:
1. Next task: "Implement payment webhook handler"
2. Classify: Complex without skill
3. Attempt execution → discover SPEC doesn't specify the webhook payload format
4. Flag: "This task can't proceed — the SPEC doesn't define the webhook payload schema. Should I update the SPEC first?"
5. Mark as blocked: "Blocked: SPEC missing webhook payload specification"
6. Move to next actionable task
Result: Block identified, upstream gap flagged, execution continues with next task

### Example 4: Resuming a paused session
User says: "Execute tasks" (TASKS.md has 3 completed, 1 in-progress, 4 pending)
Actions:
1. Load TASKS.md — detect 1 task in-progress
2. Dashboard: 3 completed, 1 in-progress, 4 pending
3. Resume the in-progress task: "Create user settings page"
4. Ask: "This task was left in-progress. Should I continue from where it left off, or restart it?"
5. User says continue → complete the task → mark completed
6. Proceed to next pending task
Result: Session resumed cleanly from prior state

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
