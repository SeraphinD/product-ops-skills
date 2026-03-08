# SPEC.md Output Template

The final `SPEC.md` must follow **exactly** this structure. A SPEC can contain **multiple User Stories**, each with its own Functional Scope and Acceptance Criteria block:

```markdown
# [Feature Name] - Specifications

> Generated from: {relative path to BRIEF.md}

## User Story [N] — {MUST | SHOULD | COULD}
As a [role], I want [capability] so that [benefit].

### Functional Scope
#### Features
- [feature 1]
- [feature 2]
- ...

### Acceptance Criteria

#### Scenario 1: [Scenario Name]
**GIVEN** [precondition]
**WHEN** [action]
**THEN** [expected outcome]

#### Scenario 2: [Scenario Name]
**GIVEN** [precondition]
**WHEN** [action]
**THEN** [expected outcome]

---

## User Story [N+1] — {MUST | SHOULD | COULD}
...

---

## WON'T Stories

> The following User Stories were identified and explicitly excluded from this version.

### User Story [N] — WON'T
As a [role], I want [capability] so that [benefit].

**Reason:** {why excluded — reference the WSJF score or scope boundary from the brief}

---

## Implementation Notes
- [technical constraint or guideline derived from the brief]
- [naming conventions, commands, exit codes, error formats, etc.]
- ...
```

> If the brief describes a single role and a single capability, one User Story is sufficient. Split into multiple User Stories only when distinct roles or fundamentally different capabilities are present in the brief.
