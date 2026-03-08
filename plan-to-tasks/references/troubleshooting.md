# Troubleshooting — plan-to-tasks

## Problem: A plan step is too broad to be a single task
**Cause:** The plan step groups multiple actions (e.g., "Set up the project structure and configure dependencies").
**Solution:** Ask: "Step {N} in Phase {X} looks broad. Should I break it into sub-tasks?" Only break when you have enough context to name sub-tasks precisely. Never invent sub-tasks.

## Problem: No skill fits a task
**Cause:** The task doesn't clearly map to any installed skill (e.g., general code writing, infrastructure setup, deployment).
**Solution:** Omit the Skill/Agent field entirely. Claude Code will execute the task using its built-in tools. If the task requires human action, note it in the task description (e.g., "Requires human: choose hosting provider and configure CI/CD").

## Problem: PLAN.md not found
**Cause:** The file doesn't exist at the expected path, or the feature name doesn't match directory naming.
**Solution:** The skill will ask: "Which plan file should I use?" Provide the exact path. If the PLAN hasn't been created yet, use the `spec-to-plan` skill first.

## Problem: Tasks have circular dependencies
**Cause:** Two tasks appear to depend on each other, usually from ambiguous plan steps.
**Solution:** Flag the circular dependency to the user: "Task A depends on Task B, but Task B also seems to need Task A. Can you clarify which should come first?" Resolve before writing.

## Problem: Task descriptions are too vague to execute later
**Cause:** The plan step was written at a high level and the task inherits that vagueness.
**Solution:** Expand the task description so someone can execute it days later without re-reading the plan. Include: what file to create or modify, what the expected outcome is, and any specific behavior. Example: instead of "Implement auth", write "Create `src/auth/login.py` — POST /login endpoint that validates credentials and returns a JWT token."

## Problem: Too many tasks generated — list feels overwhelming
**Cause:** The plan has many fine-grained steps, or broad steps were broken into many sub-tasks.
**Solution:** Review for tasks that can remain grouped without losing clarity. A plan step like "Create 3 test files" can be one task: "Create test files for auth, users, and settings modules" rather than 3 separate tasks. Ask the user about preferred granularity.

## Problem: DESIGN.md references don't map to plan steps
**Cause:** The plan was written without a DESIGN.md, or the design was added after the plan.
**Solution:** If DESIGN.md exists, scan it for component specs that align with plan steps. Add design references to task descriptions where relevant: "Create `NotificationCard` component per DESIGN.md spec (states: default, unread, loading)." Don't create extra tasks for design elements not in the plan.
