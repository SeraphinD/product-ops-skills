# Status Update Format

How `execute-tasks` modifies `TASKS.md` in-place. This skill does not produce a new artifact — it updates the existing task list.

---

## Status Line Format

Each task in TASKS.md has a status prefix. The skill reads and writes these:

```markdown
| ⬜ pending       | {N} | Task title | Phase {N}, Step {N} | Notes |
| 🔄 in_progress   | {N} | Task title | Phase {N}, Step {N} | Notes |
| ✅ completed {YYYY-MM-DD} | {N} | Task title | Phase {N}, Step {N} | Notes |
| ❌ blocked        | {N} | Task title | Phase {N}, Step {N} | Notes |
```

---

## When Starting a Task

Change:
```markdown
| ⬜ pending | 3 | Create auth middleware | Phase 1, Step 2 | Depends on: Task 1 |
```

To:
```markdown
| 🔄 in_progress | 3 | Create auth middleware | Phase 1, Step 2 | Depends on: Task 1 |
```

---

## When Completing a Task

Change:
```markdown
| 🔄 in_progress | 3 | Create auth middleware | Phase 1, Step 2 | Depends on: Task 1 |
```

To:
```markdown
| ✅ completed 2025-03-15 | 3 | Create auth middleware | Phase 1, Step 2 | Depends on: Task 1 |
```

Use today's date in `YYYY-MM-DD` format.

---

## When Blocking a Task

Change:
```markdown
| ⬜ pending | 5 | Implement webhook handler | Phase 2, Step 3 | — |
```

To:
```markdown
| ❌ blocked | 5 | Implement webhook handler | Phase 2, Step 3 | ❌ Blocked 2025-03-15: SPEC missing webhook payload schema. Depends on: SPEC update |
```

---

## Header Counts Update

After every status change, update the summary line at the top of TASKS.md:

```markdown
> Total Tasks: 12 | ⬜ Pending: 5 | 🔄 In Progress: 1 | ✅ Completed: 4 | ❌ Blocked: 2
```

Recalculate all four counts from the actual task statuses — don't rely on incrementing/decrementing.

---

## Rules

- Update after **every** status change, not in batch
- Use the **exact date** of completion/blocking, not the session start date
- Keep the Notes field — append block reasons, don't replace existing notes
- If a blocked task is later unblocked, change status back to ⬜ pending and append: `Unblocked {YYYY-MM-DD}: {reason}`
