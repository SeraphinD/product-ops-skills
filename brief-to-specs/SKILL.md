---
name: brief-to-specs
description: Transforms a BRIEF.md into a structured SPEC.md containing User Stories with MoSCoW/WSJF prioritization, Acceptance Criteria in Given/When/Then format, and Implementation Notes. Trigger on phrases like "generate specs", "create SPEC.md", "convert brief to specs", "specs from brief", "write specifications from brief", "brief to spec", "transform brief into spec", "write acceptance criteria", or when the user has a BRIEF.md and asks to derive user stories or a specification document from it. Do NOT use for creating a brief from scratch (use create-brief), benchmarking (use brief-to-benchmark), generating a plan from specs (use spec-to-plan), or designing UI (use spec-to-design). This skill converts an existing brief into specifications only.
allowed-tools: "Read Write Glob"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [spec, specifications, user-stories, acceptance-criteria, moscow, wsjf]
---

# Brief → SPEC Skill

This skill transforms a feature `BRIEF.md` into a structured `SPEC.md` containing User Stories, Acceptance Criteria in Given/When/Then format, and Implementation Notes.

## Output Template

**Before writing any output, read `references/template.md` for the exact SPEC.md structure.**

The SPEC contains: User Stories (each with MoSCoW label, Functional Scope, and Acceptance Criteria in Given/When/Then format), a WON'T Stories section, and Implementation Notes. A SPEC can contain multiple User Stories — split only when distinct roles or fundamentally different capabilities are present.

**After writing, run `bash scripts/validate-spec.sh {path-to-spec}` to verify structural completeness.**

**For cross-stage validation, run `bash scripts/validate-coverage.sh {path-to-brief} {path-to-spec}` to verify all BRIEF objectives, in-scope items, and success criteria are covered in the SPEC.**

---

## Interaction Protocol

Work section by section. For each section:
1. Share what you've derived from the brief
2. Propose a draft of the section
3. Ask for confirmation or adjustments before moving on
4. Never skip a section — if you can't write it confidently from the brief, ask a targeted question

**Never generate the full SPEC in one shot without confirming each major block** (User Stories, Functional Scope, Acceptance Criteria, Implementation Notes) with the user first.

---

## Step-by-Step Process

### Step 1 — Locate the BRIEF

Find the BRIEF.md file. Look first at:
- The path the user provides directly
- `docs/features/*/BRIEF.md` matching the feature name in context
- Any `BRIEF.md` in the current working directory

Read the file. If no BRIEF is found, ask the user to provide the path or paste the content.

### Step 2 — Load Prior Decisions

Before generating anything, check whether a `DECISION.md` exists in the same `docs/features/{feature-name}/` directory as the BRIEF.

If it exists, read it in full. Then:
- **Treat every ✅ Accepted decision as a hard constraint** — do not re-open, re-ask, or contradict it.
- If a prior decision directly conflicts with something in the BRIEF, flag the conflict to the user before proceeding: *"Decision {N} says X, but the brief says Y. Which should take precedence?"*
- Do not log prior decisions again — only log new decisions made during this skill's execution.

---

### Step 3 — Load Benchmark (if available)

Check whether a `BENCHMARK.md` exists in the same `docs/features/{feature-name}/` directory as the BRIEF.

If it exists, read it in full. Then use it as **soft guidance** — it informs the SPEC but does not override the brief:

- **Spec Recommendations** → use these to fill scope gaps in the brief, sharpen User Story benefits, and suggest acceptance criteria boundaries. If a recommendation conflicts with the brief, the brief takes precedence — but flag the conflict: *"The benchmark recommends excluding X, but the brief includes it. I'll follow the brief — note this for review."*
- **Key Metrics & Baselines** → use verified metrics (non-`⚠️`) to ground concrete values in acceptance criteria rather than vague qualifiers (e.g., prefer `< 200ms` over `fast`).
- **Gap Analysis** → use identified overlaps to sharpen scope decisions. Use risks to add edge-case scenarios to the Acceptance Criteria.

Ignore `⚠️ Unverified` metrics in the benchmark — do not carry unverified data into the SPEC as if it were fact.

If no `BENCHMARK.md` is found, proceed without it — this phase is optional.

---

### Step 4 — Analyze gaps before writing

After reading the BRIEF, before generating anything, scan each section for ambiguities that would prevent writing precise, testable specs:

- **User Stories**: Is the actor clearly identified? Is the benefit ("so that...") explicit or must it be guessed?
- **Functional Scope**: Are any in-scope items too vague to write a concrete feature bullet? (e.g., "good error handling" — what error? what message?)
- **Acceptance Criteria**: Are the expected outputs, commands, HTTP codes, or exit codes specified? Or would scenarios require pure invention?
- **Implementation Notes**: Are there technical choices (language, framework, invocation pattern) that are mentioned but unclear?
- **Assumptions & Risks**: If the brief has this section, review it. Unvalidated assumptions may need edge-case ACs. Listed risks may influence MoSCoW prioritization — a story that depends on a high-risk assumption might warrant a lower priority or an explicit boundary-condition scenario.

If you find ambiguities, **ask all your clarifying questions in a single message** — group them by section, be specific, and propose a default answer when you have a reasonable one. Do not proceed to writing until the user has answered.

If the BRIEF is complete enough to write every section without inventing details, skip straight to Step 5.

**Example of a good clarifying message:**

> Before I write the SPEC, I have a few gaps:
>
> **User Story** — The brief mentions "the admin" but doesn't specify what benefit they get. Is it to reduce manual work? To improve auditability?
>
> **Acceptance Criteria** — The brief says "show an error for invalid input" but doesn't specify the error format. Is it a JSON `{ error: string }` response, a CLI message, a toast notification?
>
> I'll default to X and Y unless you tell me otherwise.

---

### Step 5 — Extract User Stories

From the brief, derive one User Story per **distinct actor + capability pair**. The formula is always:

> As a **[role]**, I want **[capability]** so that **[benefit]**.

Rules for extracting User Stories:
- The **role** comes from the brief's target audience or actor (developer, user, admin, system, etc.)
- The **capability** is the core action or feature being provided
- The **benefit** is the "why" — the outcome or value delivered
- If the brief has multiple sections (e.g., success path + error handling + configuration), group them under one US unless they serve genuinely different actors
- Do NOT invent roles or capabilities not present or inferable from the brief

---

### Step 6 — Prioritize User Stories (MoSCoW + WSJF)

This step is **mandatory for every SPEC**, regardless of whether a BENCHMARK.md is available.

After all User Stories are confirmed in Step 5, prioritize each one individually before writing any Functional Scope or Acceptance Criteria. Use **MoSCoW**:

| Label | Meaning |
|-------|---------|
| **MUST** | Non-negotiable — the feature fails without this story |
| **SHOULD** | High value, expected by users, but a workaround exists if absent |
| **COULD** | Desirable but not critical — include if scope allows |
| **WON'T** | Explicitly out of scope for this version — noted for future reference |

For **each User Story**, present a WSJF scorecard with your recommended MoSCoW label and reasoning. Wait for the user to confirm or override before moving to the next story.

**WSJF scorecard format — present exactly this for each story:**

---
#### User Story [N] — Prioritization

**Recommended: {MUST | SHOULD | COULD | WON'T}**

| WSJF Component | Score (1, 2, 3, 5, 8, 13) | Reasoning |
|---|---|---|
| User / Business Value | {N} | {link to brief objectives, success criteria, or benchmark Spec Recommendations if available} |
| Time Criticality | {N} | {urgency — does delay erode value? competitive pressure from benchmark? market timing from brief?} |
| Risk Reduction / Opportunity Enablement | {N} | {does this unblock other stories, reduce technical risk, or enable a downstream capability?} |
| **Cost of Delay** | **{sum of above}** | |
| Job Size | {N} | {relative effort — 1 = trivial, 13 = very large; base on scope implied by the story} |
| **WSJF Score** | **{Cost of Delay ÷ Job Size:.1f}** | |

**Why {label}:** {1–2 sentences explaining the recommendation in plain language — reference the scorecard, not just the numbers. If WON'T, state explicitly what makes it out of scope.}

*Your call — confirm this label or tell me what to change:*

---

**Scoring guidance:**
- Use Fibonacci scores (1, 2, 3, 5, 8, 13) kept consistent across all stories in the same session — scores are only meaningful relative to each other; the non-linear scale intentionally forces distinction between sizes
- **User/Business Value**: draw from brief objectives and success criteria; benchmark Spec Recommendations "Include" items signal higher value
- **Time Criticality**: draw from brief context and market timing; benchmark competitive urgency signals
- **Risk Reduction**: high if this story unblocks others or addresses a benchmark-identified risk or a risk listed in the brief's Assumptions & Risks section; low if it's independent
- **Job Size**: estimate relative complexity from the story's implied scope — not a precise measure
- A high WSJF score doesn't automatically mean MUST — the MoSCoW definition still applies. If the feature can ship and be useful without a story, that story cannot be MUST regardless of its score

**After all stories are prioritized:**
- WON'T stories are excluded from Functional Scope and Acceptance Criteria — they appear only in the "WON'T Stories" section at the end of the SPEC with their reason
- COULD stories get full Functional Scope and ACs but are visibly marked — they are in scope but lowest priority
- Only log to DECISION.md when the user **overrides** the recommended label — record the AI's suggestion, the user's chosen label, and their reason. Confirmations (user agreed with the recommendation) are already captured in the SPEC and do not need a DECISION.md entry.

---

### Step 7 — Define Functional Scope per User Story

For each **MUST**, **SHOULD**, and **COULD** User Story, list the concrete features it entails. **Skip WON'T stories entirely** — they appear only in the "WON'T Stories" section at the end of the SPEC.

Pull features directly from:
- In-scope items in the brief
- Behaviors described in the solution section
- Success criteria that are feature-level (not test-level)

Keep each feature bullet specific and action-oriented (e.g., "Accept a name as a CLI argument", not "Good UX").

---

### Step 8 — Write Acceptance Criteria

For each User Story, write **at least 2 scenarios**. Coverage requirements:

| Scenario type | Required? |
|---|---|
| Happy path (valid input, expected flow) | Yes |
| Edge/error case (missing input, invalid state, failure) | Yes |
| Boundary case (empty string, max length, etc.) | If implied by the brief |

Each scenario uses strict **Given/When/Then** format:
- **GIVEN** — the precondition or system state before the action
- **WHEN** — the exact action taken (command run, button clicked, API called, etc.)
- **THEN** — the observable, testable outcome (output text, exit code, side effect, etc.)

Write scenarios so that a developer can turn each one directly into a test case without interpretation. Be concrete: include exact commands, exact output strings, exact exit codes when the brief specifies them.

If a scenario requires a specific value (an error message, an HTTP code, an output format) that the brief does not specify, **stop and ask** rather than inventing it.

**Good example:**
```
**GIVEN** a valid name "Alice"
**WHEN** I run `python -m app hello Alice`
**THEN** it prints `Hello, Alice!` to stdout and exits with code 0
```

**Bad example (too vague):**
```
**GIVEN** valid input
**WHEN** the user runs the app
**THEN** it works correctly
```

---

### Step 9 — Write Implementation Notes

Extract concrete technical constraints and guidelines directly from the brief. Focus on:
- Command invocation pattern (e.g., `python -m app`, `npm run`, `go run`)
- Exit code conventions
- Error message tone and format
- Naming or structural conventions
- Technology or framework constraints mentioned in the brief
- Anything a developer needs to know before writing the first line of code

Do NOT add implementation notes that are pure inference or good practice not grounded in the brief.

---

### Step 10 — Determine Output Path

The `SPEC.md` is **always** written to:

```
docs/features/{feature-name}/SPEC.md
```

Where `{feature-name}` is the kebab-case version of the feature name from the brief title (e.g., "JWT Authentication Endpoint" → `jwt-authentication-endpoint`).

**Resolution logic:**

1. If the BRIEF is already inside `docs/features/{feature-name}/`, write the SPEC to the same directory.
2. If the BRIEF is elsewhere (project root, current directory, arbitrary path), still write the SPEC to `docs/features/{feature-name}/SPEC.md` in the current working directory — derive `{feature-name}` from the brief's `# Project Brief:` title.
3. Create the directory if it does not exist.
4. If a `SPEC.md` already exists at that path, confirm with the user before overwriting.
5. Never ask the user where to save — always derive the path. Inform the user of the exact path before writing: *"I'll write the SPEC to `docs/features/{feature-name}/SPEC.md`."*

---

### Step 11 — Write the File

1. Assemble the complete `SPEC.md`
2. Show the full content to the user for review
3. Ask: *"Ready to write this SPEC.md?"*
4. Write the file using the Write tool

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Explicit decisions** — choices the user made when you asked a clarifying question (e.g., error format, actor role, benefit wording, whether to split User Stories)
- **Implicit decisions** — choices you made without asking because the brief was clear enough (e.g., deriving the "so that" benefit, choosing to group features under one US, selecting a scenario boundary value)
- **Functional decisions** — product-level choices about what the feature must do (e.g., specific acceptance criteria wording, edge cases included or excluded)

### What NOT to log

- Obvious, mechanical actions (e.g., "wrote the file", "used Given/When/Then format")
- Formatting or template-structure decisions already defined by the skill

### Entry format

Each decision follows this structure:

```markdown
## Decision {N}: {Short title}
**Status:** ✅ Accepted
**Date:** {YYYY-MM-DD}
**Skill:** brief-to-specs

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

> For simple decisions (e.g., confirming a scenario name), keep the entry lightweight — skip Options Considered and Consequences if they add no value. Use the full format for decisions that shape the spec's direction.

### When to write

Append decisions to `DECISION.md` as they happen during the interaction — do not batch them at the end. This ensures the log is complete even if the session is interrupted.

---

## Rules

1. **Never invent requirements** — every User Story, feature, scenario, and implementation note must be traceable to something stated or clearly implied in the brief.
2. **Precise and testable** — acceptance criteria must be binary (pass/fail) and concrete enough to automate.
3. **Cover failure paths** — at least one AC scenario per User Story must test an error, edge case, or boundary condition.
4. **No filler** — do not pad Implementation Notes with generic best practices. Only include what the brief specifies.
5. **English always** — write the SPEC.md in English regardless of the language used during the conversation.
6. **Interactive and thorough** — scan the brief for gaps before writing. Ask all clarifying questions upfront in a single message (grouped by section). Then propose each major section (User Stories, Functional Scope, Acceptance Criteria, Implementation Notes) as a draft and confirm with the user before moving on. Do not generate the full SPEC in one shot without section-by-section confirmation.
7. **Multiple USs when warranted** — if the brief covers distinct actors or fundamentally different capabilities, split into separate User Stories each with their own Functional Scope and AC blocks. Do not artificially merge or split.
8. **Always prioritize** — Step 6 (MoSCoW + WSJF) runs for every SPEC, with or without a BENCHMARK.md. Never skip it. WON'T stories must be listed in the SPEC even if excluded from all other sections.

---

## Examples

### Example 1: Simple CLI tool
User says: "Generate specs from the greeting tool brief"
Actions:
1. Locate `docs/features/greeting-tool/BRIEF.md`, read it
2. Check for DECISION.md and BENCHMARK.md in the same directory
3. Identify 1 User Story: "As a developer, I want to greet a user by name so that the CLI produces personalized output"
4. Run WSJF scorecard → recommend MUST → user confirms
5. Write 3 acceptance criteria (happy path, missing name, empty string)
6. Write Implementation Notes (Python 3.10+, `python -m app` invocation, exit code 0/1)
7. Write to `docs/features/greeting-tool/SPEC.md`
Result: A focused SPEC with 1 MUST User Story, 3 Given/When/Then scenarios, and 3 implementation notes

### Example 2: Multi-story feature with prioritization
User says: "Convert the auth brief to specs"
Actions:
1. Locate the BRIEF, identify 4 distinct capabilities → 4 User Stories
2. Run WSJF for each: Login → MUST, Registration → MUST, Password Reset → SHOULD, Social Login → COULD
3. Write Functional Scope and ACs for each (MUST gets more detailed scenarios)
4. Add WON'T section for "Admin user management" (identified as out of scope from the BRIEF)
5. Write to `docs/features/auth/SPEC.md`
Result: A SPEC with 4 prioritized User Stories, 1 WON'T story, 12 acceptance criteria total

---

## Troubleshooting

### Problem: BRIEF is too vague to write precise acceptance criteria
**Cause:** The brief uses generic language like "handle errors properly" without specifying error messages, codes, or formats.
**Solution:** Ask all clarifying questions in a single message before writing. Propose sensible defaults: "The brief says 'show an error for invalid input' but doesn't specify the format. I'll default to `{ "error": "Invalid input: {reason}" }` unless you tell me otherwise."

### Problem: User disagrees with WSJF scoring
**Cause:** WSJF scores are relative estimates — reasonable people can disagree.
**Solution:** The scorecard is a recommendation, not a verdict. When the user overrides a label, accept it immediately, log the override to DECISION.md with the user's reasoning, and move on.

### Problem: Can't determine if a story is one US or should be split
**Cause:** The brief describes multiple capabilities that could be one big story or multiple smaller ones.
**Solution:** Apply the rule: split only when there are genuinely different actors OR fundamentally different capabilities. If the same actor does related things, keep as one US with a broader Functional Scope. Ask the user when genuinely ambiguous.

### Problem: BENCHMARK.md contains unverified metrics
**Cause:** The benchmark phase flagged some data as `⚠️ Unverified`.
**Solution:** Ignore unverified metrics — do not carry them into the SPEC as if verified. Use only verified baselines for concrete AC values. If the user wants to use an unverified metric, log the decision to DECISION.md.

---

## Pipeline Iteration & Rollback

Sometimes downstream work reveals that an upstream document needs revision. This section defines how to handle backwards movement in the pipeline.

### When to Go Back

- **SPEC review reveals the BRIEF was wrong** — An objective is missing, a scope item is misframed, or a success criterion is unmeasurable. → Ask the user: *"This SPEC gap traces back to the BRIEF. Should I update the BRIEF first, then regenerate the affected SPEC sections?"*
- **Prioritization reveals scope problems** — WSJF scoring shows a MUST story is actually COULD, or a WON'T story should be in scope. → Update the SPEC's MoSCoW labels. If the change affects BRIEF scope boundaries, flag it.
- **Benchmark contradicts the BRIEF** — Research shows a core assumption is wrong. → Flag to the user: *"The benchmark found that X (from the BRIEF) is incorrect. Should I update the BRIEF before continuing?"*

### How to Go Back

1. **Never silently modify an upstream document** — always ask the user first
2. **Log the rollback decision** to DECISION.md with full context (what changed, why, what was the original)
3. **Regenerate only affected sections** — don't rewrite the entire upstream document
4. **Re-run cross-stage validation** after any upstream change: `bash scripts/validate-coverage.sh {brief} {spec}`

### What NOT to Do

- Don't modify the BRIEF to match the SPEC — the BRIEF is the source of truth for intent
- Don't skip the rollback conversation — silent upstream changes cause downstream drift
- Don't batch rollback decisions — log each one individually as it happens
