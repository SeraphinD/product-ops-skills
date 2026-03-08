---
name: create-brief
description: Interactively creates a BRIEF.md for a new feature or project through structured Q&A, producing a document with Executive Summary, Problem Statement, Solution, Objectives, Scope, and Success Criteria. Trigger on phrases like "create a brief", "write a brief", "generate BRIEF.md", "new feature brief", "start a brief", "I have an idea for a feature", "let's start a new feature", or "kick off a project". Do NOT use for converting a brief into specs (use brief-to-specs), benchmarking (use brief-to-benchmark), editing an existing brief, or any downstream pipeline step — this skill creates new briefs from scratch only.
allowed-tools: "Read Write Glob"
metadata:
  author: seraphindesumeur
  version: 1.2.0
  category: feature-pipeline
  tags: [brief, planning, requirements, discovery]
---

# Create BRIEF Skill

This skill interactively generates a `BRIEF.md` file by gathering information through targeted questions, then writing the final document into the correct location in the project.

## Output Template

The final `BRIEF.md` must follow **exactly** this structure — no extra sections, no missing sections:

```markdown
# Project Brief: [Feature/Project Name]

## Executive Summary
[2-3 sentences: what it is + why it matters]

## Problem Statement
[Framing sentence explaining the context]
- [Pain point 1]
  > "[Optional verbatim from a real user illustrating this pain point]" — [Source]
- [Pain point 2]
- [Pain point 3]

[Closing sentence: consequence of NOT solving this problem]

## Solution
[One paragraph. Bold the **core design principle** or key differentiator.]

## Key Objectives
<!-- 3 to 7 objectives -->
- ✓ [Objective 1]
- ✓ [Objective 2]
- ✓ [Objective 3]
- ...

## Scope

### In Scope
<!-- 5 to 10 items -->
- [Item 1]
- [Item 2]
- [Item 3]
- ...

### Out of Scope
<!-- 3 to 8 items -->
- [Excluded item 1]
- [Excluded item 2]
- [Excluded item 3]
- ...

## Success Criteria
<!-- 3 to 8 criteria -->
- [x] [Measurable criterion 1]
- [x] [Measurable criterion 2]
- [x] [Measurable criterion 3]
- ...
```

## Interaction Protocol

Work section by section. For each section:
1. Share what you know or have inferred
2. Ask only what is genuinely missing or ambiguous
3. Propose a draft and ask for confirmation before moving on
4. Never fill a section with vague or generic content — ask instead

**Never skip a section.** If the user hasn't provided enough to write a section confidently, ask a targeted question.

---

## Step-by-Step Process

### Step 0 — Initial Context Gathering

Start by asking the user to describe the feature or project in their own words. One open question is enough:

> "Describe the feature or project you want to brief — what it does, who it's for, and any constraints you have in mind."

From their answer, extract what you can for each section. Identify gaps before proceeding.

---

### Step 1 — Feature Name

Confirm the exact name to use in the `# Project Brief:` heading.

- If the user's description contains a clear name, propose it and confirm.
- If ambiguous, ask: *"What should I call this feature/project in the brief title?"*

---

### Step 2 — Executive Summary

Write 2–3 sentences covering:
- **What** the feature is
- **Who** it serves (if relevant)
- **Why** it matters

If the user's description is thin on "why it matters", ask:
> *"What is the main reason this feature is being built now? What does it unlock or unblock?"*

Propose a draft, ask for approval or adjustments.

---

### Step 3 — Problem Statement

Structure: opening sentence → 3+ bullet pain points → closing consequence sentence.

If the pain points aren't clear, ask:
> *"What specific problems or frustrations does this solve? What happens today without this feature?"*

Once the pain points are drafted, ask if the user has verbatims to reinforce them:
> *"Do you have any customer verbatims (direct quotes, feedback) that illustrate these pain points? This is optional — if you do, I'll integrate them as inline quotes under the relevant pain points."*

If the user provides verbatims:
- Place each verbatim as a blockquote directly under the pain point it best illustrates
- Format: `> "Verbatim quote" — Source`
- A pain point can have zero or one verbatim — not every pain point needs one
- Keep verbatims short and impactful — trim if the user provides long quotes, with their approval

If the user has no verbatims, move on without them.

Propose a draft. Ask: *"Does this capture the problem accurately? Anything to add or change?"*

---

### Step 4 — Solution

One paragraph describing the high-level solution. Bold the core design principle.

If the approach isn't clear, ask:
> *"How will this feature solve the problem at a high level? Is there a key design choice or constraint that defines the approach?"*

Propose a draft. Confirm before continuing.

---

### Step 5 — Key Objectives

3 to 7 objectives, each prefixed with `✓`. Action-oriented, one line each.

Derive objectives from the context gathered so far. If fewer than 3 emerge naturally, ask:
> *"What else should this feature achieve beyond what we've covered? Any technical, operational, or process goals?"*

Propose the list. Ask for confirmation.

---

### Step 6 — Scope: In Scope

5 to 10 concrete deliverable items. Be specific — avoid vague entries like "good UX" or "proper implementation".

Derive from the solution and objectives. If gaps remain, ask:
> *"What specific components, behaviors, or deliverables must be included? Think about commands, outputs, validations, tests, and documentation."*

Propose the list. Confirm.

---

### Step 7 — Scope: Out of Scope

3 to 8 explicit exclusions. Be specific about what is NOT being built.

Think about adjacent features, future ideas, and common assumptions that could creep into scope. If unsure, ask:
> *"What are the things people might expect from this feature that you deliberately don't want to include right now?"*

Propose the list. Confirm.

---

### Step 8 — Success Criteria

3 to 8 criteria, all marked `[x]`. Each must be:
- **Binary** — pass or fail
- **Specific** — include exact commands, outputs, or behaviors where relevant
- **Verifiable** — someone else can check it without ambiguity

Derive from the acceptance criteria implied by the scope and solution. If criteria are vague, ask:
> *"How will you know this feature is done and working correctly? What would you test or check?"*

Propose the list. Confirm.

---

### Step 9 — Output Location

The file is **always** written to:

```
docs/features/{feature-name}/BRIEF.md
```

Where `{feature-name}` is the kebab-case version of the feature name confirmed in Step 1 (e.g., "User Authentication" → `user-authentication`).

- Create the directory if it does not exist.
- If a `BRIEF.md` already exists at the target path, inform the user and ask for confirmation before overwriting.
- Never ask the user where to save the file — the path is fixed.
- Inform the user of the exact path before writing: *"I'll write the file to `docs/features/{feature-name}/BRIEF.md`."*

---

### Step 10 — Write the File

Once all sections are confirmed:
1. Assemble the final `BRIEF.md` content
2. Show the complete document to the user for a final review
3. Ask: *"Ready to write this file?"*
4. Write the file to the confirmed path using the Write tool

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Explicit decisions** — choices the user made when you asked a question (e.g., feature name, scope inclusion/exclusion, success criterion wording)
- **Implicit decisions** — choices you made without asking because the brief context made them clear (e.g., inferring the target audience, choosing to group pain points a certain way, deriving an objective from the solution)
- **Functional decisions** — product-level choices about what the feature does or doesn't do, who it serves, what problem it solves

### What NOT to log

- Obvious, mechanical actions (e.g., "wrote the file to the correct path", "used markdown formatting")
- Formatting or template-structure decisions already defined by the skill

### Entry format

Each decision follows this structure:

```markdown
## Decision {N}: {Short title}
**Status:** ✅ Accepted
**Date:** {YYYY-MM-DD}
**Skill:** create-brief

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

> For simple decisions (e.g., confirming a feature name), keep the entry lightweight — skip Options Considered and Consequences if they add no value. Use the full format for decisions that shape the feature's direction.

### When to write

Append decisions to `DECISION.md` as they happen during the interaction — do not batch them at the end. This ensures the log is complete even if the session is interrupted.

---

## Rules

1. **Interactive first** — never generate the full brief from a single message without asking at least one clarifying question per ambiguous section.
2. **Propose, don't impose** — always show a draft of each section and ask for feedback before locking it in.
3. **No placeholders in the final file** — every field must contain real content.
4. **Strict structure** — no extra sections (no Timeline, Stack, Dependencies, Risks, Stakeholders). Only the 7 sections defined in the template.
5. **Counts** — 3–7 objectives, 5–10 in-scope items, 3–8 out-of-scope items, 3–8 success criteria. Stay within these ranges — ask for more input if below the minimum, trim if above the maximum.
6. **Language** — write the BRIEF.md in English, regardless of the language the user uses to interact.
7. **One section at a time** — do not dump all questions at once. Work through sections sequentially.

---

## Examples

### Example 1: Feature with clear context
User says: "Create a brief for a dark mode toggle feature"
Actions:
1. Ask the user to describe the feature — who it's for, why it matters, any constraints
2. Confirm the feature name: "Dark Mode Toggle"
3. Draft Executive Summary → confirm → Draft Problem Statement → confirm → ... (section by section)
4. Write to `docs/features/dark-mode-toggle/BRIEF.md`
Result: A complete BRIEF.md with all 7 sections, written interactively over ~10 exchanges

### Example 2: Vague initial input
User says: "I need a brief for notifications"
Actions:
1. Ask: "Describe the notification feature — what it does, who it's for, and any constraints"
2. User provides a thin answer — skill identifies gaps in Problem Statement and Success Criteria
3. Ask targeted questions for each gap before drafting those sections
4. Propose defaults where reasonable, confirm with the user
Result: A complete BRIEF.md built through deeper questioning to compensate for sparse initial context

### Example 3: User provides rich detail upfront
User says: "Brief for a JWT auth endpoint — it's for our REST API, developers need it to get tokens, we're using Node.js with Express, tokens expire after 1h, refresh tokens last 7d"
Actions:
1. Extract all provided info, identify only genuine gaps (e.g., out-of-scope items, success criteria thresholds)
2. Draft most sections directly from context, asking fewer questions
3. Confirm each section, write to `docs/features/jwt-auth-endpoint/BRIEF.md`
Result: A complete BRIEF.md produced faster due to rich initial context, with fewer clarifying questions

---

## Troubleshooting

### Problem: BRIEF.md already exists at the target path
**Cause:** A previous session or manual creation left a file at `docs/features/{feature-name}/BRIEF.md`.
**Solution:** The skill will inform you and ask for confirmation before overwriting. If you want to keep the old version, rename it manually before proceeding.

### Problem: User provides all info in one message and expects instant output
**Cause:** The skill is designed to be interactive — it works section by section.
**Solution:** Even with rich context, the skill will still propose each section as a draft and ask for confirmation. This ensures quality. If the user explicitly requests "generate it all at once", remind them that section-by-section confirmation catches errors early.

### Problem: Fewer than 3 objectives or success criteria
**Cause:** The brief's scope is narrow or the user hasn't thought deeply about goals.
**Solution:** Ask targeted questions: "What else should this feature achieve beyond what we've covered? Any technical, operational, or process goals?" If the user genuinely has fewer, explain the minimum range (3–7 objectives, 3–8 criteria) and help them reach it.

### Problem: Success criteria are vague or not binary
**Cause:** User provides subjective criteria like "app should feel fast" or "good error handling".
**Solution:** Push for specifics: "What exact behavior would you check? Can you frame it as a pass/fail test?" Transform vague criteria into binary, verifiable statements.
