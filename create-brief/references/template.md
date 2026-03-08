# BRIEF.md Output Template

The final `BRIEF.md` must follow **exactly** this structure — no extra sections, no missing sections:

```markdown
# Project Brief: {Feature/Project Name}

## Executive Summary
{2-3 sentences: what it is + who it serves + why it matters}

## Problem Statement
{Framing sentence explaining the context}
- {Pain point 1}
  > "{Optional verbatim from a real user illustrating this pain point}" — {Source}
- {Pain point 2}
- {Pain point 3}

{Closing sentence: consequence of NOT solving this problem}

## Solution
{One paragraph. Bold the **core design principle** or key differentiator.}

## Key Objectives
<!-- 3 to 7 objectives -->
- ✓ {Objective 1}
- ✓ {Objective 2}
- ✓ {Objective 3}
- ...

## Scope

### In Scope
<!-- 5 to 10 items -->
- {Item 1}
- {Item 2}
- {Item 3}
- ...

### Out of Scope
<!-- 3 to 8 items -->
- {Excluded item 1}
- {Excluded item 2}
- {Excluded item 3}
- ...

## Assumptions & Risks
<!-- All three subsections are optional. Include only those that apply. -->
<!-- No forced item count — list only what is genuinely relevant. -->

### Assumptions
<!-- Things we believe to be true but haven't validated. Omit if none. -->
- {Assumption 1}

### Risks
<!-- What could go wrong or block success. Omit if none. -->
- {Risk 1}

### Mitigations
<!-- How we'd reduce or handle a risk listed above. Omit if none. -->
- {Mitigation 1}

## Success Criteria
<!-- 3 to 8 criteria -->
- [x] {Measurable criterion 1}
- [x] {Measurable criterion 2}
- [x] {Measurable criterion 3}
- ...
```

## Constraints

- **Exactly 8 sections** — no extra sections (no Timeline, Stack, Dependencies, Stakeholders)
- **Counts** — 3–7 objectives, 5–10 in-scope items, 3–8 out-of-scope items, 3–8 success criteria
- **Objectives** — prefixed with `✓`, action-oriented, one line each
- **Success Criteria** — marked `[x]`, binary (pass/fail), specific, verifiable
- **Assumptions & Risks** — all three subsections optional; include only what genuinely applies
- **Verbatims** — optional blockquotes under pain points; format: `> "Quote" — Source`
- **Solution** — one paragraph with **bolded core design principle**
- **No placeholders** — every field must contain real content in the final file
