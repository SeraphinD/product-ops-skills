# Decision Log Format

Shared format for `DECISION.md` entries across all product ops skills.

---

## General Rules

- **Location:** `docs/features/{feature-name}/DECISION.md`
- **Create** the file if it does not exist
- **Append** new decisions — never overwrite existing ones
- **Write as you go** — append decisions as they happen during the interaction. Do not batch them at the end. This ensures the log is complete even if the session is interrupted.

---

## What NOT to Log

- Obvious, mechanical actions (e.g., "wrote the file", "used the template", "created the directory")
- Formatting or template-structure decisions already defined by the skill

---

## Entry Format

Each decision follows this structure:

```markdown
## Decision {N}: {Short title}
**Status:** ✅ Accepted
**Date:** {YYYY-MM-DD}
**Skill:** {skill-name}

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

> For simple decisions (e.g., confirming a name or a default value), keep the entry lightweight — skip Options Considered and Consequences if they add no value. Use the full format for decisions that shape the feature's direction.
