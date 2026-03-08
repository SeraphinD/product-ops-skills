---
name: spec-to-plan
description: Transforms a SPEC.md into a structured PLAN.md — a phased, MoSCoW-ordered implementation plan with project structure, concrete steps per file, critical files list, verification checklist, and implementation details. Trigger on phrases like "generate plan", "create PLAN.md", "convert spec to plan", "plan from spec", "write implementation plan", "spec to plan", "make a plan from the spec", "turn spec into a plan", or when the user has a SPEC.md and wants actionable implementation steps — even if they don't say "PLAN.md" explicitly. Do NOT use for generating specs from a brief (use brief-to-specs), generating a task list from a plan (use plan-to-tasks), or designing UI (use spec-to-design). This skill produces implementation plans from specifications only.
allowed-tools: "Read Write Glob"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [plan, implementation, architecture, project-structure, phases]
---

# SPEC → PLAN Skill

This skill transforms a `SPEC.md` (or any specification file) into a structured `PLAN.md` — a phased, actionable implementation plan with project structure, concrete steps, critical files, and a verification checklist.

## Output Template

**Before writing any output, read `references/template.md` for the exact PLAN.md structure.**

The PLAN contains: Overview, Requirements Summary, Project Structure (file tree), Implementation Steps (MoSCoW-ordered phases), Critical Files, Verification Checklist, and Implementation Details (technical topics, error messages, constraints).

**After writing, run `bash scripts/validate-plan.sh {path-to-plan}` to verify structural completeness.**

---

## Interaction Protocol

Work section by section. For each section:
1. Share what you've derived from the spec
2. Propose a draft of the section
3. Ask for confirmation or adjustments before moving on
4. Never skip a section — if you can't write it confidently from the spec, ask a targeted question

**Never generate the full PLAN in one shot without confirming each major block** (Requirements Summary, Project Structure, Implementation Phases, Critical Files, Verification Checklist, Implementation Details) with the user first.

---

## Step-by-Step Process

### Step 1 — Locate the SPEC

Find the specification file. Look in this order:
1. The path the user provides directly
2. `docs/features/*/SPEC.md` matching any feature name in context
3. Any `SPEC.md` in the current working directory

Read the file in full. If no SPEC is found, ask the user to provide the path or paste the content.

When reading User Stories, extract the MoSCoW label from each header (e.g., `## User Story 1 — MUST`). Group them mentally before proceeding:
- **MUST** — non-negotiable, must be in Phase 1
- **SHOULD** — high value, Phase 2
- **COULD** — optional, Phase 3 (can be dropped without breaking core functionality)
- **WON'T** — excluded; ignore entirely. Do not generate any implementation steps for WON'T stories.

If the SPEC has no MoSCoW labels (generated before this convention), treat all User Stories as MUST and proceed normally.

### Step 2 — Load Prior Decisions

Before generating anything, check whether a `DECISION.md` exists in the same `docs/features/{feature-name}/` directory as the SPEC.

If it exists, read it in full. Then:
- **Treat every ✅ Accepted decision as a hard constraint** — do not re-open, re-ask, or contradict it.
- If a prior decision directly conflicts with something in the SPEC, flag the conflict to the user before proceeding: *"Decision {N} says X, but the spec says Y. Which should take precedence?"*
- Do not log prior decisions again — only log new decisions made during this skill's execution.

---

### Step 3 — Load DESIGN.md (if available)

Check whether a `DESIGN.md` exists in the same `docs/features/{feature-name}/` directory as the SPEC.

If it exists, read it in full. Then use it to inform the plan:

- **Project Structure** — include component files, style files, and design system files implied by the DESIGN.md (e.g., `src/components/Button.tsx`, `src/styles/theme.ts`, `src/styles/colors.ts`)
- **Implementation Phases** — when a DESIGN.md exists, the first sub-phase of Phase 1 (MUST) should be "Design System Setup": establishing design tokens (colors, typography, spacing) and base component scaffolding before feature-specific code
- **Critical Files** — include component files and design system files as critical when the DESIGN.md defines them
- **Implementation Details** — add a "Frontend Design Implementation" subsection covering the styling approach, component patterns, and design token setup derived from the DESIGN.md
- **Verification Checklist** — add design-specific items: "Components match DESIGN.md specifications", "Color palette matches DESIGN.md", "Responsive breakpoints match DESIGN.md", "WCAG 2.1 AA requirements from DESIGN.md met"

If a DESIGN.md component uses specific states or variants, ensure the plan includes steps to implement each state.

If no `DESIGN.md` is found, proceed without it — this phase is optional.

---

### Step 4 — Analyze gaps before writing

After reading the SPEC, before generating anything, scan each section for information that would be needed to produce a complete, unambiguous plan:

- **Feature name** — Is a clear name present to derive the `{feature-name}` folder slug?
- **Tech stack** — Is the language, framework, or runtime explicitly stated or clearly implied?
- **Project structure** — Are source folder names and entry points specified, or must they be inferred?
- **Implementation phases** — Are there multiple distinct steps that naturally group into phases, or is the scope small enough for a single phase?
- **Error handling** — Are error messages or exit codes specified in the spec?
- **Test strategy** — Is there a testing framework mentioned, or should one be assumed?
- **Design document** — Is there a DESIGN.md? If so, does it specify a styling approach (CSS-in-JS, Tailwind, plain CSS)? If not specified in either the spec or design, ask the user.

If any of these are ambiguous, **ask all clarifying questions in a single message** — group them by section (e.g., "Stack", "Project structure"), propose a sensible default for each, and wait for the user to confirm or correct.

If the spec is complete enough to fill every section without guessing, skip straight to Step 5.

**Example of a good clarifying message:**

> Before I write the PLAN, I have a few gaps:
>
> **Stack** — The spec mentions Python but doesn't specify a version. I'll assume Python 3.10+ unless you say otherwise.
>
> **Testing** — No test framework is mentioned. I'll default to `pytest`. OK?
>
> **Feature name** — I'll use `user-authentication` as the folder slug. Does that match what you have in mind?
>
> Let me know if any of these need adjusting and I'll proceed.

---

### Step 5 — Extract the Requirements Summary

From the spec, pull out the key facts that define the feature:
- The primary command, endpoint, or entry point
- The required tech stack
- The expected success output (return value, printed text, HTTP response, etc.)
- The error handling strategy (error messages, exit codes, HTTP status codes)

Stick to what the spec states. Do not add requirements not grounded in the spec.

---

### Step 6 — Design the Project Structure

Build a realistic file tree based on the spec's implied or explicit structure. Rules:
- Always include `docs/features/{feature-name}/SPEC.md` and `PLAN.md` in the tree — so the plan is self-contained and reviewable in context alongside its source spec
- Group source files under a logical folder (e.g., `src/`, `app/`, `lib/`)
- Always include a `tests/` directory — even if it's empty, it signals test coverage is planned
- Include `README.md` at the root
- Only include files that are actually needed — don't pad the tree with speculative extras; an inflated tree misleads developers about what needs to be built
- If a DESIGN.md exists, include: a `styles/` or `theme/` directory for design tokens, component files matching the DESIGN.md component list under a `components/` directory, and layout files if the DESIGN.md defines page layouts

---

### Step 7 — Define Implementation Phases

Organize phases by MoSCoW priority order, then add Testing and Documentation at the end:

- **Phase 1 — MUST:** implement all MUST User Stories' functional scope
- **Phase 2 — SHOULD:** implement all SHOULD User Stories' functional scope *(omit if none)*
- **Phase 3 — COULD (optional):** implement COULD User Stories' functional scope *(omit if none; mark explicitly as droppable)*
- **Phase N — Testing:** write automated tests covering ACs for all included stories (MUST + SHOULD; COULD if the phase is kept)
- **Phase N+1 — Documentation:** README and any other docs

**Rules for phase ordering:**
- Never plan a SHOULD or COULD story's implementation before all MUST stories are fully planned
- If all stories share the same label, organize Phase 1 sub-phases by natural dependency order instead (e.g., data model → business logic → API layer)
- For small features (< 5 source files total), collapse same-label stories into a single phase rather than splitting artificially
- The COULD phase must include a visible note in the PLAN: *"This phase is optional — it can be dropped without affecting core functionality."*

When a DESIGN.md exists for the feature, the first sub-phase of Phase 1 (MUST) should be "Design System Setup" — creating the design tokens, base theme, and component scaffolding as defined in DESIGN.md. Subsequent steps in Phase 1 build on top of these base components.

Each step within a phase must be specific: name the file and describe what it contains, not just "add some code."

---

### Step 8 — Identify Critical Files

List only the files whose absence would break the feature — the entry point, core logic file, and test file. Not every file in the tree is "critical." Keeping this list short forces reviewers to focus on what matters most, and signals to implementors which files to get right first.

---

### Step 9 — Write the Verification Checklist

Pull directly from the spec's acceptance criteria. Each item must be a concrete, checkable statement:
- Prefer exact commands: `python -m app hello Alice` → `Hello, Alice!` (exit 0) — exact commands prevent ambiguous checks that developers interpret differently and miss in review
- Include the test run command as its own checklist item — a passing test suite is the minimal bar before shipping

---

### Step 10 — Fill in Implementation Details

For each non-obvious technical choice (CLI parsing library, routing pattern, error format), add a subsection explaining:
- What to use — so implementors don't make inconsistent choices independently
- How to configure it — so setup isn't a discovery task during implementation
- Any gotchas the spec implies — surfacing these here prevents mid-sprint surprises

Include a **Constraints & Guidelines** subsection for any implementation-level guidelines or constraints from the spec (naming conventions, library choices, invocation patterns).

When a DESIGN.md exists, add a dedicated subsection:

### Frontend Design Implementation
{Derived from DESIGN.md — styling approach, component library setup, theme configuration, responsive strategy, design token values (colors, typography scale, base unit), and component architecture patterns.}

Only include what the spec and design specify or what is needed to implement them. Do not pad with generic best-practice advice.

---

### Step 11 — Determine Output Path

The `PLAN.md` is **always** written to:

```
docs/features/{feature-name}/PLAN.md
```

Where `{feature-name}` is the kebab-case version of the feature name (e.g., "JWT Authentication Endpoint" → `jwt-authentication-endpoint`).

**Resolution logic:**

1. If the SPEC is already inside `docs/features/{feature-name}/`, write the PLAN to the same directory.
2. Otherwise, derive `{feature-name}` from the spec's title and write to `docs/features/{feature-name}/PLAN.md` in the current working directory.
3. Create the directory if it does not exist.
4. If a `PLAN.md` already exists at that path, confirm with the user before overwriting.
5. Never ask the user where to save — always derive the path. Inform the user before writing: *"I'll write the PLAN to `docs/features/{feature-name}/PLAN.md`."*

---

### Step 12 — Write the File

1. Assemble the complete `PLAN.md` using the template above
2. Show the full content to the user for review
3. Ask: *"Ready to write this PLAN.md?"*
4. Write the file using the Write tool

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Explicit decisions** — choices the user made when you asked a clarifying question (e.g., tech stack version, test framework, phase breakdown)
- **Implicit decisions** — choices you made without asking because the spec was clear enough (e.g., choosing a project structure convention, selecting a CLI parsing library, deciding phase order)
- **Functional decisions** — product-level choices that affect how the feature is built (e.g., grouping logic into specific files, choosing an error handling pattern)
- **Architectural decisions** — structural choices about project layout, dependency order, or technology selection

### What NOT to log

- Obvious, mechanical actions (e.g., "wrote the file", "created the directory")
- Formatting or template-structure decisions already defined by the skill

### Entry format

Each decision follows this structure:

```markdown
## Decision {N}: {Short title}
**Status:** ✅ Accepted
**Date:** {YYYY-MM-DD}
**Skill:** spec-to-plan

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

> For simple decisions (e.g., confirming a default framework), keep the entry lightweight — skip Options Considered and Consequences if they add no value. Use the full format for decisions that shape the plan's architecture.

### When to write

Append decisions to `DECISION.md` as they happen during the interaction — do not batch them at the end. This ensures the log is complete even if the session is interrupted.

---

## Rules

1. **Traceable to the spec** — every phase, step, file, and detail must be grounded in the spec. Do not invent requirements or files not implied by the spec.
2. **Concrete and actionable** — each implementation step must name a specific file and describe what it does. "Create the main module" is too vague; "Create `app/__main__.py` — CLI entry point that parses arguments and routes to subcommands" is correct.
3. **Cover error paths** — the Verification Checklist must include at least one error/edge-case scenario from the spec's acceptance criteria.
4. **No filler** — do not add Notes, Implementation Details, or checklist items that are generic best practices not grounded in the spec.
5. **English always** — write the PLAN.md in English regardless of the language used in the conversation.
6. **Interactive and thorough** — scan the spec for gaps before writing. Ask all clarifying questions upfront in a single message, grouped by section. Propose defaults. Then propose each major section as a draft and confirm with the user before moving on. Do not generate the full PLAN in one shot without section-by-section confirmation.
7. **Right-sized phases** — match the number of phases to the actual complexity. Don't force three phases onto a trivial feature; don't collapse a complex feature into one phase.
8. **Respect MoSCoW ordering** — phases must follow MUST → SHOULD → COULD. Never plan a lower-priority story's implementation before all higher-priority stories are covered. WON'T stories are never planned, referenced, or included in any phase. SPECs without MoSCoW labels treat all stories as MUST.

---

## Examples

### Example 1: Simple CLI tool with one phase
User says: "Generate a plan from the greeting tool spec"
Actions:
1. Locate `docs/features/greeting-tool/SPEC.md` — 1 MUST User Story
2. Extract requirements: Python 3.10+, CLI entry point, exit codes 0/1
3. Propose a simple project structure (3 source files, 1 test file)
4. Generate 1 MUST phase + Testing phase + Documentation phase
5. Write 5 critical files, 4 verification checklist items
6. Write to `docs/features/greeting-tool/PLAN.md`
Result: A lean PLAN.md with 3 phases, matching the small scope

### Example 2: Multi-phase feature with DESIGN.md
User says: "Plan from the dashboard spec"
Actions:
1. Locate SPEC — 3 MUST, 1 SHOULD, 1 COULD User Stories
2. Load DESIGN.md — extract component list, design tokens, page layouts
3. Phase 1 (MUST): Design System Setup + 3 MUST stories implementation
4. Phase 2 (SHOULD): 1 SHOULD story
5. Phase 3 (COULD, optional): 1 COULD story with "can be dropped" note
6. Phase 4: Testing, Phase 5: Documentation
7. Include "Frontend Design Implementation" subsection in Implementation Details
Result: A PLAN.md with 5 phases, design system integration, and MoSCoW-ordered implementation

---

## Troubleshooting

### Problem: SPEC has no clear tech stack
**Cause:** The specification doesn't mention a language, framework, or runtime.
**Solution:** Ask in the gap analysis phase: "The spec doesn't specify a tech stack. I'll assume {reasonable default based on context}. OK?" Propose a default based on any clues (file extensions mentioned, test frameworks, etc.).

### Problem: Feature is too small for multiple phases
**Cause:** The spec describes a trivial feature with 1-2 source files.
**Solution:** Collapse into a single implementation phase. Don't artificially split small features into phases. The Testing and Documentation phases still exist separately.

### Problem: DESIGN.md exists but conflicts with SPEC
**Cause:** The design document was written before a spec change, or they were authored independently.
**Solution:** The SPEC takes precedence for functional requirements. The DESIGN.md provides UI implementation guidance. Flag conflicts: "The DESIGN.md shows component X, but the SPEC doesn't mention this functionality. Should I include it in the plan?"

### Problem: Verification checklist items are vague
**Cause:** The spec's acceptance criteria use vague language that doesn't translate to concrete checks.
**Solution:** Transform vague criteria into specific checkable statements. Instead of "handles errors properly", write: `python -m app hello "" → 'Error: Name cannot be empty' (exit 1)`. If the spec doesn't provide enough detail, flag the gap.
