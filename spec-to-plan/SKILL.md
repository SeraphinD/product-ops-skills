---
name: spec-to-plan
description: Transforms a SPEC.md into a structured PLAN.md — a phased, MoSCoW-ordered implementation plan with project structure, concrete steps per file, critical files list, verification checklist, implementation details, and experiment infrastructure when A/B tests are defined. Optionally reads visual mockups from a design tool MCP (Figma or Paper) when a DESIGN.md references one, providing visual context alongside the structured design document. Trigger on phrases like "generate plan", "create PLAN.md", "convert spec to plan", "plan from spec", "write implementation plan", "spec to plan", "make a plan from the spec", "turn spec into a plan", "plan experiment infrastructure", or when the user has a SPEC.md and wants actionable implementation steps — even if they don't say "PLAN.md" explicitly. Do NOT use for generating specs from a brief (use brief-to-specs), generating a task list from a plan (use plan-to-tasks), or designing UI (use spec-to-design). This skill produces implementation plans from specifications only.
allowed-tools: "Read Write Glob"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [plan, implementation, architecture, project-structure, phases, figma, paper, mcp]
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

When reading User Stories, also detect `### Experimentation Strategy` blocks. Note which User Stories have experiments and collect their `EXP-IDs`. This information is needed in Steps 4 and 7.

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

### Step 3b — Load Visual Mockups from Design Tool (if available)

If a `DESIGN.md` was loaded in Step 3 and it references a design tool in its "Design Files & References" section (a Figma link/file key or a Paper link/file), check whether the corresponding design tool MCP is available in this session.

**Detection:**
- **Figma MCP**: Look for tools like `get_metadata`, `get_design_context`, `get_variable_defs`, `get_screenshot` whose descriptions reference Figma.
- **Paper MCP**: Look for tools like `get_tree_summary`, `get_screenshot`, `get_computed_styles`, `get_basic_info` whose descriptions reference Paper.

**If the referenced design tool MCP is available:**

1. **Figma**: call `get_metadata` to identify the pages and frames relevant to this feature (look for a page named `[Feature Name] — Generated` or matching the feature name). Then call `get_screenshot` on each key frame to capture the current visual state of the mockups.
2. **Paper**: call `get_tree_summary` to identify the artboards relevant to this feature. Then call `get_screenshot` on each key artboard to capture the current visual state.

Use the screenshots as **supplementary visual context** alongside the structured DESIGN.md data. They help assess:
- **Visual complexity** — how dense are the layouts, how many distinct elements per screen
- **Component fidelity** — whether the mockups have been fleshed out beyond the initial scaffold
- **Spacing and layout precision** — details that ASCII wireframes can't capture
- **Implementation effort** — visual complexity informs step granularity in the plan

This step is **read-only** — no modifications to the design tool. If the design tool MCP is not available or the DESIGN.md doesn't reference one, skip this step and rely on the DESIGN.md text alone.

---

### Step 4 — Load Compliance Review Artifacts (if available)

Check whether any of the following exist in `docs/features/{feature-name}/`:
- `GDPR-REVIEW.md`
- `ACCESSIBILITY-REVIEW.md`
- `AI-ACT-REVIEW.md`

For each one found, read it in full. Then use them to inform the plan:

- **Implementation Phases** — add compliance-specific implementation steps to the relevant phase. For example: consent flow implementation (from GDPR review), accessibility testing setup (from accessibility review), AI transparency UI (from AI Act review). These steps slot into the existing MoSCoW-ordered phases alongside the feature implementation steps — they are not a separate phase.
- **Verification Checklist (Step 9)** — add compliance verification items derived from each review's findings. For example: "GDPR consent flow works as specified", "WCAG AA contrast ratios met", "AI interaction disclosure visible to users".
- **Implementation Details (Step 10)** — add a "Compliance Implementation" subsection covering the specific compliance requirements, the tools/libraries needed (e.g., cookie consent library, axe-core for a11y testing, model card template), and any constraints from the reviews.

If a review's compliance acceptance criteria include concrete Given/When/Then scenarios, carry them into the Verification Checklist as checkable items.

If no compliance review artifacts are found, proceed without them — this input is optional.

---

### Step 5 — Analyze gaps before writing

After reading the SPEC, before generating anything, scan each section for information that would be needed to produce a complete, unambiguous plan:

- **Feature name** — Is a clear name present to derive the `{feature-name}` folder slug?
- **Tech stack** — Is the language, framework, or runtime explicitly stated or clearly implied?
- **Project structure** — Are source folder names and entry points specified, or must they be inferred?
- **Implementation phases** — Are there multiple distinct steps that naturally group into phases, or is the scope small enough for a single phase?
- **Error handling** — Are error messages or exit codes specified in the spec?
- **Test strategy** — Is there a testing framework mentioned, or should one be assumed?
- **Design document** — Is there a DESIGN.md? If so, does it specify a styling approach (CSS-in-JS, Tailwind, plain CSS)? If not specified in either the spec or design, ask the user.
- **Experimentation tooling** — If the SPEC contains `### Experimentation Strategy` blocks, ask: *"The SPEC includes experiments. Do you have an experimentation platform available (e.g., LaunchDarkly, Unleash, Optimizely, GrowthBook, Statsig, custom feature flags)?"* Three response paths:
  - **Has tooling** (user names a platform): Plan experiment infrastructure using that platform. Reference its API/SDK in Implementation Details.
  - **No tooling, wants experiments**: Recommend lightweight alternatives: *"You can run experiments without a dedicated platform. Options include: (a) environment variable-based flags, (b) percentage-based routing with a simple random seed, (c) server-side config with manual cohort assignment. Which do you prefer?"* Plan with the chosen approach.
  - **No tooling, doesn't want experiment infrastructure**: Skip the "Experiment Infrastructure" sub-phase. Keep variant User Stories as regular implementation. Add a note in Implementation Details: *"Experiment infrastructure was deferred — variant features will be shipped directly without A/B testing."* Log this decision to DECISION.md.
- **Compliance reviews** — Were compliance review artifacts loaded in Step 4? If so, do they introduce implementation requirements (consent flows, accessibility testing, AI transparency) that need dedicated plan steps?

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

### Step 6 — Extract the Requirements Summary

From the spec, pull out the key facts that define the feature:
- The primary command, endpoint, or entry point
- The required tech stack
- The expected success output (return value, printed text, HTTP response, etc.)
- The error handling strategy (error messages, exit codes, HTTP status codes)

Stick to what the spec states. Do not add requirements not grounded in the spec.

---

### Step 7 — Design the Project Structure

Build a realistic file tree based on the spec's implied or explicit structure. Rules:
- Always include `docs/features/{feature-name}/SPEC.md` and `PLAN.md` in the tree — so the plan is self-contained and reviewable in context alongside its source spec
- Group source files under a logical folder (e.g., `src/`, `app/`, `lib/`)
- Always include a `tests/` directory — even if it's empty, it signals test coverage is planned
- Include `README.md` at the root
- Only include files that are actually needed — don't pad the tree with speculative extras; an inflated tree misleads developers about what needs to be built
- If a DESIGN.md exists, include: a `styles/` or `theme/` directory for design tokens, component files matching the DESIGN.md component list under a `components/` directory, and layout files if the DESIGN.md defines page layouts

---

### Step 8 — Define Implementation Phases

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

When the SPEC contains `### Experimentation Strategy` blocks **and** experimentation tooling is available (confirmed in Step 4), add an "Experiment Infrastructure" sub-phase as the first sub-phase of Phase 1 (MUST) — analogous to the "Design System Setup" sub-phase. This covers: feature flag system setup, analytics event instrumentation for primary and guardrail metrics, and variant routing logic. Ensure variant User Stories that share an `EXP-ID` are grouped under their parent experiment in the phase structure. If experimentation was deferred (no tooling), skip this sub-phase — variant stories are planned as regular implementation steps.

Each step within a phase must be specific: name the file and describe what it contains, not just "add some code."

---

### Step 9 — Identify Critical Files

List only the files whose absence would break the feature — the entry point, core logic file, and test file. Not every file in the tree is "critical." Keeping this list short forces reviewers to focus on what matters most, and signals to implementors which files to get right first.

---

### Step 10 — Write the Verification Checklist

Pull directly from the spec's acceptance criteria. Each item must be a concrete, checkable statement:
- Prefer exact commands: `python -m app hello Alice` → `Hello, Alice!` (exit 0) — exact commands prevent ambiguous checks that developers interpret differently and miss in review
- Include the test run command as its own checklist item — a passing test suite is the minimal bar before shipping

When the plan includes experiment infrastructure, add these checklist items:
- `[ ] Feature flag toggles correctly between control and variant`
- `[ ] Primary metric events fire in both control and variant paths`
- `[ ] Guardrail metric events fire in both paths`
- `[ ] Users in control group see existing behavior (no regression)`

---

### Step 11 — Fill in Implementation Details

For each non-obvious technical choice (CLI parsing library, routing pattern, error format), add a subsection explaining:
- What to use — so implementors don't make inconsistent choices independently
- How to configure it — so setup isn't a discovery task during implementation
- Any gotchas the spec implies — surfacing these here prevents mid-sprint surprises

Include a **Constraints & Guidelines** subsection for any implementation-level guidelines or constraints from the spec (naming conventions, library choices, invocation patterns).

When a DESIGN.md exists, add a dedicated subsection:

### Frontend Design Implementation
{Derived from DESIGN.md — styling approach, component library setup, theme configuration, responsive strategy, design token values (colors, typography scale, base unit), and component architecture patterns.}

When the plan includes experiment infrastructure, add a dedicated subsection:

### Experimentation Infrastructure
{Derived from SPEC Experimentation Strategy blocks — tooling choice (platform name or lightweight approach), traffic allocation mechanism (e.g., 50/50 random split, percentage-based), analytics pipeline (where events go, how they're aggregated), and kill switch procedure (how to shut down the experiment if guardrails are breached).}

Only include what the spec and design specify or what is needed to implement them. Do not pad with generic best-practice advice.

---

### Step 12 — Determine Output Path

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

### Step 13 — Write the File

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

For entry format, shared exclusions, and writing rules, see `references/decision-log-format.md`.

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
9. **Experimentation is adaptive** — when the SPEC has experiments, ask about tooling before planning infrastructure. Plan with the user's actual tooling, recommend lightweight alternatives if none exists, or defer experiment infrastructure entirely if the user prefers. Never assume a specific experimentation platform.

---

## Pipeline Iteration

Sometimes planning work reveals that an upstream document needs revision. This section defines when to go back and how.

### When to Go Back

- **SPEC is too vague for file-level implementation steps** — an acceptance criterion or functional scope item doesn't provide enough detail to name concrete files or describe what they contain. Ask the user: *"The SPEC's {item} is too vague to plan at the file level. Should I update the SPEC with more detail first?"*
- **DESIGN.md is incomplete** — components mentioned in the SPEC lack design treatment in DESIGN.md (missing states, no wireframe, no accessibility spec). Flag it: *"The PLAN needs design details for {component} that DESIGN.md doesn't cover. Should I update the DESIGN first?"*
- **Tech stack gaps make project structure impossible to derive** — the SPEC and Implementation Notes don't specify enough about the tech stack (language, framework, runtime) to define a project structure. Ask the user to update the SPEC's Implementation Notes or clarify directly.
- **MoSCoW ordering reveals missing dependencies** — a SHOULD story depends on a COULD story, or a MUST story requires infrastructure not mentioned in the SPEC. Flag it: *"The implementation order reveals a dependency the SPEC doesn't account for. Should the SPEC be updated?"*

For the universal rollback protocol (how to go back, what not to do, decision log format), see `references/pipeline-iteration.md`.

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

For common issues and solutions, consult `references/troubleshooting.md`.
