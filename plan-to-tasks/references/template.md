# TASKS.md Output Template

The final `TASKS.md` must follow **exactly** this structure:

```markdown
# TASKS.md

> Generated from: {relative path to PLAN.md}
> Date: {YYYY-MM-DD}
> Total Tasks: {N} | ⬜ Pending: {N} | 🔄 In Progress: {N} | ✅ Completed: {N} | ❌ Blocked: {N}

---

## Phase {N} — {Phase Name}

### {Action verb} `{target file or component}` — {short purpose}
- **Status:** ⬜ pending
- **Description:** {1–2 sentences — what exactly needs to happen and why}
- **PLAN Reference:** {relative path to PLAN}, Phase {N}, Step {N}
- **Skill/Agent:** {skill name and role, e.g. `frontend-design`} *(optional — only include when a task maps to an installed skill)*
- **Notes:** {constraints, dependencies on other tasks, or "none"}

{...repeat for every task in this phase}

---

## Phase {N+1} — {Phase Name}

{...}

---

## Summary

| Phase | Name | Tasks | Skills Involved |
|-------|------|-------|-----------------|
| Phase 1 | {name} | {N} | {skill-a, skill-b, or "—" if none} |
| **Total** | | **{N}** | |
```
