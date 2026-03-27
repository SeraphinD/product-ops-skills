# Execute Tasks — Troubleshooting

Common issues encountered during task execution and how to resolve them.

---

## TASKS.md Issues

### No TASKS.md found
**Symptom:** The skill can't find a TASKS.md to work from.
**Cause:** The task list hasn't been generated yet, or it's in an unexpected location.
**Fix:** Run `plan-to-tasks` first to generate TASKS.md from PLAN.md, or ask the user to provide the path directly.

### TASKS.md has inconsistent counts
**Symptom:** The header summary counts don't match the actual task statuses in the table.
**Cause:** Manual edits or a prior interrupted session.
**Fix:** Recalculate counts from the actual table rows. Run `bash scripts/validate-execution.sh {path-to-TASKS.md}` to detect and report inconsistencies.

### All tasks show as pending but work has been done
**Symptom:** Files exist or tests pass, but TASKS.md still shows everything as pending.
**Cause:** Work was done outside the execution skill without updating statuses.
**Fix:** Walk through each task, verify whether its outcome already exists, and update statuses accordingly. Confirm each status change with the user.

---

## Dependency Issues

### Circular dependency detected
**Symptom:** Task A depends on Task B which depends on Task A.
**Cause:** PLAN.md had an implicit dependency loop that wasn't caught during task generation.
**Fix:** Ask the user which task should be done first. Log the dependency resolution as a decision in DECISION.md.

### Dependency on a blocked task
**Symptom:** The next actionable task depends on a task that is blocked.
**Cause:** The blocking task has an unresolved issue.
**Fix:** Check the block reason. If it's an upstream artifact issue, follow `references/pipeline-iteration.md`. If it's an external block, skip to the next task that has no dependency chain through the blocked task.

### Missing dependency information
**Symptom:** A task fails because it requires output from another task, but no dependency was listed.
**Cause:** The PLAN didn't capture the dependency.
**Fix:** Add the dependency to the task's Notes field, mark the current task as blocked if the dependency isn't completed, and log the discovery in DECISION.md.

---

## Execution Issues

### Simple task turns out to be complex
**Symptom:** A task classified as "simple" requires multi-file changes, external APIs, or non-trivial logic.
**Cause:** The task description in TASKS.md was too brief, or the PLAN underestimated complexity.
**Fix:** Stop execution, reclassify the task as "complex," propose a detailed approach to the user, and get confirmation before continuing.

### Task outcome doesn't match SPEC acceptance criteria
**Symptom:** The task is done but the result doesn't satisfy the SPEC's Given/When/Then scenarios.
**Cause:** The task description was interpreted differently from the SPEC's intent.
**Fix:** Don't mark the task as completed. Show the discrepancy between the implementation and the AC, ask the user how to align them, then re-execute.

### Skill delegation fails
**Symptom:** The user invoked the assigned skill but the output doesn't cover the task.
**Cause:** The skill's scope doesn't match the task, or the task was poorly defined.
**Fix:** Check if the task needs to be split, if the skill assignment was wrong, or if additional context is needed for the skill. Update TASKS.md with the corrected assignment.

---

## Artifact Issues

### DECISION.md doesn't exist yet
**Symptom:** Need to log a decision but there's no DECISION.md.
**Cause:** No prior decisions were logged for this feature.
**Fix:** Create the file at `docs/features/{feature-name}/DECISION.md` with a header and the first decision entry.

### SPEC.md is missing for verification
**Symptom:** Can't verify a task because the acceptance criteria aren't available.
**Cause:** The SPEC wasn't generated or is in a different location.
**Fix:** Ask the user to point to the SPEC. If no SPEC exists, verification falls back to the task description and PLAN.md context — but flag the gap.

### Conflicting decisions in DECISION.md
**Symptom:** Two decisions contradict each other.
**Cause:** A later decision overrode an earlier one without being marked as a rollback.
**Fix:** Ask the user which decision takes precedence. Log the resolution as a new decision with explicit reference to both prior entries.
