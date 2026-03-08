---
name: create-brief
description: Interactively creates a BRIEF.md for a new feature or project through structured Q&A, producing a document with Executive Summary, Problem Statement, Solution, Objectives, Scope, Assumptions & Risks, and Success Criteria. Trigger on phrases like "create a brief", "write a brief", "generate BRIEF.md", "new feature brief", "start a brief", "I have an idea for a feature", "let's start a new feature", or "kick off a project". Do NOT use for converting a brief into specs (use brief-to-specs), benchmarking (use brief-to-benchmark), editing an existing brief, or any downstream pipeline step — this skill creates new briefs from scratch only.
allowed-tools: "Read Write Glob"
license: MIT
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

## Assumptions & Risks
<!-- All three subsections are optional. Include only those that apply. -->
<!-- No forced item count — list only what is genuinely relevant. -->

### Assumptions
<!-- Things we believe to be true but haven't validated. Omit if none. -->
- [Assumption 1]

### Risks
<!-- What could go wrong or block success. Omit if none. -->
- [Risk 1]

### Mitigations
<!-- How we'd reduce or handle a risk listed above. Omit if none. -->
- [Mitigation 1]

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

### Step 0 — Check for Existing Problem Frame

Before gathering context, check whether a `PROBLEM-FRAME.md` already exists in the target feature directory (`docs/features/{feature-name}/PROBLEM-FRAME.md`). If the feature name is not yet known, check after confirming it in Step 1.

**If `PROBLEM-FRAME.md` exists:**
1. Read it fully
2. Use it as the primary source for the brief — the validated problem statement, root cause, constraints, success definition, and chosen frame should flow directly into the brief's Problem Statement, Scope, and Success Criteria sections
3. Inform the user: *"I found a PROBLEM-FRAME.md for this feature. I'll use the validated problem statement and constraints as the foundation for the brief."*
4. Ask fewer questions in later steps — the problem frame has already answered most of them
5. If the problem frame's chosen framing conflicts with what the user says, flag it: *"The problem frame says X, but you're describing Y. Which should the brief follow?"*

**If `PROBLEM-FRAME.md` does not exist:**
Proceed normally with context gathering below. The problem frame is optional — the brief works fine without it.

Also check for `DECISION.md` in the same directory. If it exists, read it and treat all ✅ Accepted decisions as hard constraints.

### Step 0.5 — Initial Context Gathering

Start by asking the user to describe the feature or project in their own words. One open question is enough:

> "Describe the feature or project you want to brief — what it does, who it's for, and any constraints you have in mind."

If a `PROBLEM-FRAME.md` was found, you can skip this question and instead summarize what the problem frame covers, then ask: *"The problem frame covers the problem and constraints. What solution are you thinking of, and are there any additional objectives or scope items beyond what the frame covers?"*

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

**If a `PROBLEM-FRAME.md` exists:** Derive the pain points directly from the problem frame's Problem Statement, Root Cause Analysis, and Stress Test. The framing sentence should align with the chosen frame's Selected Problem Statement. Propose the draft and confirm — the user may want to adjust the language for a brief audience.

If the pain points aren't clear (and no problem frame exists), ask:
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

**If a `PROBLEM-FRAME.md` exists:** Seed the out-of-scope list from the problem frame's Problem Boundaries and the Chosen Frame's Deprioritizes list. These were deliberately excluded during problem framing and should carry forward.

Think about adjacent features, future ideas, and common assumptions that could creep into scope. If unsure, ask:
> *"What are the things people might expect from this feature that you deliberately don't want to include right now?"*

Propose the list. Confirm.

---

### Step 8 — Assumptions & Risks

Surface the bets the brief is making. All three subsections are optional — include only those that genuinely apply. There is no minimum or maximum item count.

**Assumptions** — things the brief treats as true but that haven't been validated. These often hide in the Problem Statement ("users want X") and Solution ("the API supports Y"). Scan the brief for implicit beliefs and make them explicit.

**If a `PROBLEM-FRAME.md` exists:** Pull assumptions from the problem frame's Stress Test (evidence basis) and Root Cause Analysis. Any "Why" answer that rests on an unverified belief is a candidate assumption.

If assumptions aren't obvious, ask:
> *"What are we taking for granted here? Is there anything in the problem, solution, or scope that we believe to be true but haven't actually confirmed?"*

**Risks** — what could go wrong or block success. Think about: technical feasibility, dependencies on external systems, team capacity, user adoption, regulatory changes, or competitive moves.

**Mitigations** — how to reduce or handle each risk. Only include if a risk has a known mitigation. If it doesn't, that's fine — an unmitigated risk is still useful to name.

If there are genuinely no assumptions, risks, or mitigations worth stating, the section can be empty with a note: *"No significant assumptions or risks identified at this stage."* But probe before accepting that — most briefs have at least one hidden assumption.

Propose a draft. Confirm.

---

### Step 9 — Success Criteria

3 to 8 criteria, all marked `[x]`. Each must be:
- **Binary** — pass or fail
- **Specific** — include exact commands, outputs, or behaviors where relevant
- **Verifiable** — someone else can check it without ambiguity

**If a `PROBLEM-FRAME.md` exists:** Use the problem frame's Measurable Signals and Target State as a starting point. Convert them into binary pass/fail criteria where possible. The problem frame's "What Success is NOT" section can inform what to explicitly exclude from criteria.

Derive from the acceptance criteria implied by the scope and solution. If criteria are vague, ask:
> *"How will you know this feature is done and working correctly? What would you test or check?"*

Propose the list. Confirm.

---

### Step 10 — Output Location

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

### Step 11 — Write the File

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
4. **Strict structure** — no extra sections (no Timeline, Stack, Dependencies, Stakeholders). Only the 8 sections defined in the template. Assumptions & Risks subsections are optional — include only those that apply.
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
Result: A complete BRIEF.md with all 8 sections, written interactively over ~10 exchanges

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

### Example 4: Problem frame exists upstream
User says: "Create a brief for enterprise auth gaps"
Actions:
1. Check `docs/features/enterprise-auth-gaps/` — find existing `PROBLEM-FRAME.md` and `DECISION.md`
2. Read the problem frame: chosen framing is about identity infrastructure gaps blocking enterprise adoption, root cause is SMB-era auth architecture, constraints include backward compatibility
3. Summarize: "I found a problem frame that identifies enterprise identity infrastructure gaps as the core problem. I'll use that as the foundation. What solution approach are you thinking of?"
4. Derive Problem Statement pain points from the frame's root cause analysis and stress test
5. Seed Out of Scope from the frame's Problem Boundaries and Deprioritizes list
6. Seed Success Criteria from the frame's Measurable Signals
7. Ask fewer questions — focus on Solution, Objectives, and In Scope (which the problem frame doesn't cover)
Result: A complete BRIEF.md grounded in the validated problem frame, produced faster with fewer questions because the problem definition is already done

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
