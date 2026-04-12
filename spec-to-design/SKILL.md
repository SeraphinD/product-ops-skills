---
name: spec-to-design
description: Transforms a SPEC.md into a structured DESIGN.md for frontend features — covering design system (colors, typography, spacing), components with states and variants, page layouts with ASCII wireframes, user flows, interactions, and WCAG 2.1 AA accessibility requirements. Optionally integrates with a design tool MCP (Figma or Paper) to read existing design tokens and scaffold frames directly in the design tool after writing DESIGN.md. Trigger on phrases like "generate design", "create DESIGN.md", "design from spec", "spec to design", "create UI design", "design system from spec", "component design from spec", "frontend design", "write design document from spec", or "design the feature". Do NOT use for backend-only features, CLI tools, or API-only services without a user interface — this skill is frontend-specific. Do NOT use for generating implementation plans (use spec-to-plan) or task lists (use plan-to-tasks).
allowed-tools: "Read Write Glob Grep"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.1.0
  category: feature-pipeline
  tags: [design, ui, frontend, design-system, components, accessibility, wireframes, figma, paper, mcp]
---

# SPEC → DESIGN Skill

This skill transforms a `SPEC.md` into a structured `DESIGN.md` — a frontend/UI design document covering design system, components, page layouts, user flows, interactions, and accessibility requirements.

This is the **optional design phase** of the feature pipeline:

```
BRIEF.md → [BENCHMARK.md] → SPEC.md → [DESIGN.md] → PLAN.md → TASKS.md
```

Its purpose is to ensure frontend features have a concrete, reviewable design specification before implementation planning begins. Users can skip this phase and go directly from SPEC to PLAN. This skill exists for when the feature involves UI and the team wants design decisions documented upfront.

---

## Output Template

**Before writing any output, read `references/template.md` for the exact DESIGN.md structure.**

The DESIGN contains: Design Overview, Design Goals, Design System (Color Palette, Typography, Spacing), Components (with states/variants/accessibility), Page Layouts (with ASCII wireframes), User Flows, Interactions & Animations, Accessibility Requirements, optional Dark Mode, Responsive Design Details, Design Files & References, and a Checklist for Design Approval.

**After writing, run `bash scripts/validate-design.sh {path-to-design}` to verify structural completeness.**

---

## Interaction Protocol

Work section by section. For each section:
1. Share what you've derived from the spec
2. Propose a draft of the section
3. Ask for confirmation or adjustments before moving on
4. Never skip a section — if you can't write it confidently from the spec, ask a targeted question

**Never generate the full DESIGN in one shot without confirming each major block** (Design Goals, Design System, Components, Page Layouts, User Flows, Interactions, Accessibility, Responsive) with the user first.

---

## Step-by-Step Process

### Step 1 — Detect Design Tool MCP (always run first)

Before doing anything else, check whether a design tool MCP is available in this session. The skill supports **Figma MCP** and **Paper MCP**.

**Detection:**
- **Figma MCP**: Look for tools like `get_metadata`, `get_design_context`, `get_variable_defs`, `get_screenshot`, `create_design_system_rules`, `add_code_connect_map` whose descriptions reference Figma.
- **Paper MCP**: Look for tools like `create_artboard`, `write_html`, `get_computed_styles`, `get_screenshot`, `get_tree_summary`, `get_basic_info`, `update_styles`, `set_text_content`.

**If both Figma and Paper MCP tools are detected:**
Ask: *"I detected both Figma MCP and Paper MCP. Which design tool would you like to connect for this feature? (Figma / Paper / Neither — markdown only)"*
Set the chosen tool's mode to `active` and the other to `unavailable`. If the user declines both, set both to `markdown-only`.

**If only Figma MCP tools are detected:**
1. Check if a Figma file URL or key is already in context (user message, BRIEF.md, or SPEC.md — look for `figma.com/file/` links or a `figmaFileKey` annotation).
2. If not found, ask: *"I detected Figma MCP. Do you want to connect this design to a Figma file? If yes, share the file URL or key — I'll read your existing styles and variables from it, and optionally scaffold the design directly in Figma."*
3. If the user provides a file URL or key, store it as `FIGMA_FILE_KEY` and set `FIGMA_MODE = active`.
4. If the user declines or provides nothing, set `FIGMA_MODE = markdown-only` and proceed as a normal run.

**If only Paper MCP tools are detected:**
1. Verify connectivity by calling `get_basic_info` to confirm Paper is reachable and a file is open.
2. Ask: *"I detected Paper MCP. Would you like me to read your existing styles from Paper and optionally scaffold the design directly in Paper after writing DESIGN.md?"*
3. If the user confirms, set `PAPER_MODE = active`.
4. If the user declines, set `PAPER_MODE = markdown-only` and proceed as a normal run.

**If no design tool MCP is detected:**
Set `FIGMA_MODE = unavailable` and `PAPER_MODE = unavailable`. Proceed normally — the skill produces `DESIGN.md` only. No design-tool-related prompts or steps apply for the rest of this run.

Log to `DECISION.md`: `Design tool MCP detected — {Figma: [active with file key {key} / markdown-only / unavailable], Paper: [active / markdown-only / unavailable]}`.

---

### Step 2 — Locate the SPEC

Find the specification file. Look in this order:
1. The path the user provides directly
2. `docs/features/*/SPEC.md` matching any feature name in context
3. Any `SPEC.md` in the current working directory

Read the file in full. If no SPEC is found, ask the user to provide the path or paste the content.

When reading User Stories, extract the MoSCoW label from each header (e.g., `## User Story 1 — MUST`). Group them mentally before proceeding:
- **MUST** — full design treatment (all states, variants, wireframes, flows)
- **SHOULD** — moderate design treatment (components, layouts, key states)
- **COULD** — minimal design treatment (mentioned in overview, component stubs with a note that detailed design is deferred)
- **WON'T** — excluded; do not design anything for WON'T stories

If the SPEC has no MoSCoW labels (generated before this convention), treat all User Stories as MUST and proceed normally.

---

### Step 3 — Load Prior Decisions

Before generating anything, check whether a `DECISION.md` exists in the same `docs/features/{feature-name}/` directory as the SPEC.

If it exists, read it in full. Then:
- **Treat every ✅ Accepted decision as a hard constraint** — do not re-open, re-ask, or contradict it.
- If a prior decision directly conflicts with a design choice, flag the conflict to the user before proceeding: *"Decision {N} says X, but the design would benefit from Y. Which should take precedence?"*
- Do not log prior decisions again — only log new decisions made during this skill's execution.

---

### Step 4 — Load BRIEF (context)

Check whether a `BRIEF.md` exists in the same `docs/features/{feature-name}/` directory.

If it exists, read it for contextual information:
- **Problem Statement** → informs Design Overview (what pain the UI must address)
- **Solution** → informs Design Goals (the core design principle)
- **Key Objectives** → informs Design Goals (what the UI must achieve)
- **Success Criteria** → informs measurable design targets

If no BRIEF is found, proceed with SPEC data only.

---

### Step 5 — Load Accessibility Review (if available)

Check whether an `ACCESSIBILITY-REVIEW.md` exists in the same `docs/features/{feature-name}/` directory.

If it exists, read it in full. Then use it to inform the design:

- **Design System** — incorporate contrast requirements and focus style specifications from the review's findings
- **Components** — use the review's component-level findings (ARIA patterns, keyboard interactions, VoiceOver/TalkBack labels) to define each component's accessibility behavior upfront rather than deriving from scratch in Step 15
- **Accessibility Requirements (Step 15)** — when writing the accessibility section, start from the review's findings and compliance ACs rather than the generic WCAG checklist. Add the review's specific recommendations as requirements.

If the review flagged specific contrast ratios, touch target sizes, or screen reader patterns, treat them as **hard requirements** in the design — the same way prior decisions from DECISION.md are treated.

If no `ACCESSIBILITY-REVIEW.md` is found, proceed without it — this input is optional.

---

### Step 5b — Load Benchmark Visual References (if available)

Check whether a `BENCHMARK.md` exists in the same `docs/features/{feature-name}/` directory.

If it exists, read it and extract:
- **Visual References** → competitor layout patterns and user flow diagrams become reference material. Use as inspiration, never copy.
- **Technical Standards** → any design-related standards (e.g., WCAG, Material Design guidelines) inform Accessibility Requirements and Design System.
- **Spec Recommendations** → design-relevant "Include" or "Exclude" items.

If no BENCHMARK.md exists, proceed without it — this input is optional.

---

### Step 6 — Detect Frontend Feature

This skill only applies to features with a user interface. Before proceeding, verify the SPEC describes a frontend feature.

**Detection logic:**

1. Scan the SPEC for frontend indicators: UI, interface, page, component, screen, button, form, layout, design, dashboard, modal, flow, animation, visual, CSS, HTML, React, Vue, Angular, Svelte, Next.js, Nuxt, responsive, mobile, browser, frontend, view, template, widget, dialog, navigation, sidebar, header, footer, theme, icon, image, SVG, Tailwind, styled-components.
2. Also check the BRIEF (if loaded) for tech stack mentions.
3. Classification:
   - **Clearly frontend** → proceed normally
   - **Clearly backend/CLI/data** → inform the user: *"This SPEC appears to describe a backend/CLI feature. DESIGN.md is intended for features with a user interface. Would you like to skip the design phase and go directly to PLAN?"*
   - **Ambiguous** → ask: *"I'm not sure if this feature involves a UI. Does it have frontend components that need design? If yes, I'll create a DESIGN.md."*

Log the feature type detection to `DECISION.md`.

---

### Step 7 — Detect Existing Design System

**If `FIGMA_MODE = active` — Figma-first path:**

Query the Figma file before scanning the codebase — Figma is the source of truth when connected.

1. **Get document structure**: call `get_metadata` to get an overview of the file — page names, node IDs, layer types, positions, and sizes. Identify pages that contain design system components, style guides, or token definitions.
2. **Extract variables**: call `get_variable_defs` on relevant nodes to extract variable definitions — colors, fonts, sizes, and spacings as reusable tokens (e.g., `{'icon/default/secondary': '#949494'}`).
3. **Extract design context**: call `get_design_context` on key nodes (component frames, style guide sections) to extract detailed style information — fills, strokes, text properties, effects, and layout data.
4. **Visual verification**: call `get_screenshot` on the design system page or key component frames to visually confirm what was extracted.
5. **Report findings**: *"I found {N} color variables, {M} text styles, and {K} spacing tokens in your Figma file. I'll treat these as the existing design system."* Mark all Figma-sourced tokens as `✦ Figma` in the Design System section.
6. **Then scan the codebase** (using the patterns below) to find any implementation-side tokens not yet reflected in Figma. Mark these as `⚠ Codebase-only (not synced to Figma)` and flag them to the user.
7. **Resolve conflicts**: if the same token name carries different values in Figma vs the codebase (e.g., `primary` is `#3B82F6` in Figma but `#2563EB` in `tailwind.config.ts`), ask: *"Token `{name}` differs between Figma ({figma value}) and the codebase ({code value}). Which is the design source of truth?"* Log the resolution to `DECISION.md`.

Skip to **What to do with findings** after this — do not repeat the codebase-only flow for tokens already resolved from Figma.

---

**If `PAPER_MODE = active` — Paper-first path:**

Query the Paper file before scanning the codebase — Paper is the source of truth when connected.

1. **Get document overview**: call `get_tree_summary` to understand the document structure — existing pages, artboards, and component hierarchy.
2. **Extract styles**: call `get_computed_styles` on key nodes (artboards, text nodes, containers) to extract color values, font families, sizes, weights, and spacing. If the file has a dedicated styles/tokens page or component library, prioritize reading from those nodes.
3. **Extract font info**: call `get_font_family_info` to identify the font families in use across the document.
4. **Report findings**: *"I found {N} color values, {M} text styles, and {K} font families in your Paper file. I'll treat these as the existing design system."* Mark all Paper-sourced tokens as `✦ Paper` in the Design System section.
5. **Then scan the codebase** (using the patterns below) to find any implementation-side tokens not yet reflected in Paper. Mark these as `⚠ Codebase-only (not synced to Paper)` and flag them to the user.
6. **Resolve conflicts**: if the same token name carries different values in Paper vs the codebase, ask: *"Token `{name}` differs between Paper ({paper value}) and the codebase ({code value}). Which is the design source of truth?"* Log the resolution to `DECISION.md`.

Skip to **What to do with findings** after this — do not repeat the codebase-only flow for tokens already resolved from Paper.

---

**If all design tool modes are `markdown-only` or `unavailable` — codebase-only path:**

Before asking the user anything about design tokens, proactively scan the codebase for an existing design system. Search for:

**Config files:**
- `tailwind.config.*` (Tailwind CSS — extract colors, fonts, spacing, breakpoints from `theme.extend`)
- `theme.*`, `tokens.*`, `design-tokens.*` (custom design token files)
- `styled-theme.*`, `stitches.config.*`, `panda.config.*` (CSS-in-JS theme configs)

**Source files:**
- `**/styles/variables.css`, `**/styles/theme.css`, `**/globals.css` — scan for CSS custom properties (`--color-*`, `--font-*`, `--spacing-*`)
- `**/theme.ts`, `**/theme.js`, `**/tokens.ts`, `**/tokens.js` — scan for exported theme objects
- `**/design-system/**`, `**/styles/**`, `**/theme/**` — any directory suggesting a design system

**Package dependencies:**
- Check `package.json` for UI libraries (`@mui/material`, `@chakra-ui/react`, `shadcn`, `antd`, `@radix-ui/*`, `daisyui`, etc.)
- Check for CSS frameworks (`tailwindcss`, `bootstrap`, `bulma`)

**What to extract when found (codebase-only):**
- Color palette (names, hex values, semantic roles)
- Typography scale (font families, sizes, weights)
- Spacing scale (base unit, scale values)
- Breakpoints
- Existing component patterns (naming convention, file structure, prop patterns)

**What to do with findings:**

- **Existing design system found** → store the extracted values internally. In Step 10, **reuse them as-is** instead of proposing new ones. Inform the user: *"I found an existing design system in `{path}`. I'll extend it rather than create a new one."* Log this to `DECISION.md`.
- **UI library detected but no custom tokens** → note the library. In Step 10, propose tokens that align with the library's conventions. Inform the user: *"The project uses {library}. I'll align the design system with its conventions."*
- **Nothing found** → proceed normally. Step 10 will propose a new design system from scratch.

---

### Step 8 — Analyze gaps before writing

After reading the SPEC and scanning the codebase (Step 7), scan for remaining information needed to write a complete design document:

- **UI components** — Does the spec imply specific components (forms, tables, cards, navigation, modals)?
- **Pages/screens** — Are routes, views, or screens mentioned or implied?
- **User flows** — Are the acceptance criteria detailed enough to derive step-by-step user flows?
- **Tech stack** — Is a CSS framework or component library mentioned? (Skip if already resolved by Step 7 codebase scan.)
- **Responsive requirements** — Is mobile/tablet/desktop behavior mentioned?
- **Accessibility** — Are there specific accessibility requirements beyond the default WCAG 2.1 AA?
- **Dark mode** — Is dark mode mentioned or expected?

If you find ambiguities, **ask all clarifying questions in a single message** — group them by topic, be specific, and propose a default answer when you have a reasonable one. Do not proceed to writing until the user has answered.

If the SPEC is complete enough to write every section without inventing details, skip straight to Step 9.

**Example of a good clarifying message (when existing design system was found):**

> Before I write the DESIGN, I have a few gaps:
>
> **Design system** — I found your existing design system in `src/styles/theme.ts` (Tailwind + custom tokens). I'll reuse your colors, typography, and spacing. I'll only add tokens needed for this feature's new components.
>
> **Dark mode** — Your theme file defines dark mode colors. Should I include a Dark Mode section mapping the new components to your existing dark palette?
>
> **Pages** — The SPEC has 3 user stories but doesn't mention specific routes. I'll infer pages from the functional scope. Does that work?

**Example of a good clarifying message (when no design system was found):**

> Before I write the DESIGN, I have a few gaps:
>
> **Tech stack** — The SPEC mentions React but doesn't specify a CSS approach. I'll assume Tailwind CSS unless you say otherwise.
>
> **Design system** — I didn't find an existing design system in the project. I'll create one from scratch. Any preferences (Material-inspired, Shadcn-style, fully custom)?
>
> **Dark mode** — Not mentioned in the SPEC. I'll skip the Dark Mode section. OK?

---

### Step 9 — Design Overview and Goals

Derive the Design Overview from:
- SPEC overview and user story benefits
- BRIEF problem statement and solution (if loaded)
- BENCHMARK gap analysis (if loaded)

Write 3–6 Design Goals that are:
- Concrete and tied to SPEC user stories or functional scope
- Not generic ("clean design", "modern feel" are not acceptable)
- Verifiable — someone can check whether the goal was met

Propose a draft. Ask for confirmation.

---

### Step 10 — Define the Design System

Generate Color Palette, Typography, and Spacing & Layout.

**Rules:**
- **If Step 7 found an existing design system, you MUST reuse it.** Import the detected values (colors, typography, spacing, breakpoints) directly into the Design System section. Do not propose alternatives for values that already exist — only extend with new tokens the feature requires. Clearly mark which values are inherited (`✦ Existing`) vs new (`★ New`).
- If Step 7 detected a UI library but no custom tokens, align proposed values with the library's conventions and defaults
- If Step 7 found nothing, propose a minimal, accessible palette from scratch and confirm with the user
- All colors must meet WCAG 2.1 AA contrast ratios (4.5:1 for normal text, 3:1 for large text)
- Typography must include at least H1, H2, Body, Button, and Caption
- Spacing must define a base unit, a spacing scale, and breakpoints
- All values must be concrete — hex codes, pixel sizes, font names. No vague entries.

Propose a draft. Ask for confirmation.

---

### Step 11 — Design Components (MoSCoW-aware)

For each User Story in the SPEC (excluding WON'T), extract implied components from the functional scope. Tag each component with its source story and MoSCoW label.

**Treatment depth by MoSCoW:**

| Label | Treatment |
|-------|-----------|
| **MUST** | Full — all states, variants, ASCII wireframe if complex, usage, accessibility |
| **SHOULD** | Moderate — states, usage, accessibility. Variants if clearly implied. |
| **COULD** | Minimal — name, brief description, source story, note: *"Detailed design deferred — implement if COULD phase is kept."* |

Do not design components for WON'T stories.

Propose components in batches (group by source story). Confirm each batch before moving on.

---

### Step 12 — Design Page Layouts

For each distinct page or screen implied by the SPEC:

1. Draw an ASCII box-drawing diagram showing component placement. Use `│`, `─`, `┌`, `┐`, `└`, `┘`, `├`, `┤`, `┬`, `┴`, `┼` for borders and structure. Label each element inside the diagram.
2. List key elements with their location and purpose.
3. Define responsive behavior (mobile vs desktop).
4. Tag with source story and MoSCoW label.

Apply the same MoSCoW depth as components: MUST pages get full layouts, SHOULD pages get moderate layouts, COULD pages get stubs.

Propose each layout as a draft. Confirm before moving on.

---

### Step 13 — Define User Flows

For each acceptance criteria scenario in the SPEC that involves user interaction:

1. Derive a user flow showing the step-by-step interaction
2. Include the success path and at least one error/edge-case path
3. Use ASCII flow diagrams
4. Tag with source story

Focus on flows that involve multiple steps or decision points. Single-action scenarios (e.g., "click button → see result") don't need a flow diagram.

Propose the flows. Confirm before moving on.

---

### Step 14 — Define Interactions & Animations

Cover page transitions, hover effects, loading states, and error state animations.

**Rules:**
- Keep minimal unless the SPEC explicitly requires rich interactions
- For COULD stories, omit interaction details or add a stub
- Specify concrete values: duration in ms, easing function, animation type
- Avoid over-specifying — the implementation can refine details

Propose a draft. Confirm.

---

### Step 15 — Define Accessibility Requirements

Start with the standard WCAG 2.1 AA checklist from the template. Then add SPEC-specific requirements:

- Form-specific accessibility from SPEC acceptance criteria (label associations, error announcements)
- Screen reader considerations for key components (ARIA roles, live regions)
- Keyboard navigation paths for user flows (focus order, keyboard shortcuts)
- Motion considerations (`prefers-reduced-motion`)

If BENCHMARK.md mentioned accessibility standards, incorporate them.

Propose a draft. Confirm.

---

### Step 16 — Dark Mode and Responsive Details

**Dark Mode:**
- Only include if the SPEC, BRIEF, or user explicitly mentions dark mode
- If not mentioned, add a note in the output: *"Dark mode: Not in scope for this version."* and omit the section
- If included, define the color mapping (light → dark) and implementation notes

**Responsive Details:**
- Always include mobile and desktop sections
- Include tablet if the SPEC mentions it or the feature has complex layouts
- Derive layout changes from page layouts defined in Step 12
- Specify touch target sizes for mobile (minimum 44x44px)

Propose a draft. Confirm.

---

### Step 17 — Design Decisions & Rationale

Summarize the key design choices made during this interaction. These complement the DECISION.md entries but are embedded in the DESIGN.md for readers who don't check the decision log.

For each notable choice:
- What was decided
- Why (reasoning)
- What alternatives were considered
- Impact on UX

Keep this section concise — 3–6 decisions that genuinely shape the design.

---

### Step 18 — Determine Output Path

The `DESIGN.md` is **always** written to:

```
docs/features/{feature-name}/DESIGN.md
```

Where `{feature-name}` is the kebab-case version of the feature name.

**Resolution logic:**

1. If the SPEC is already inside `docs/features/{feature-name}/`, write the DESIGN to the same directory.
2. Otherwise, derive `{feature-name}` from the spec's title and write to `docs/features/{feature-name}/DESIGN.md` in the current working directory.
3. Create the directory if it does not exist.
4. If a `DESIGN.md` already exists at that path, confirm with the user before overwriting.
5. Never ask the user where to save — always derive the path. Inform the user before writing: *"I'll write the DESIGN to `docs/features/{feature-name}/DESIGN.md`."*

---

### Step 19 — Write the File

Once all sections are confirmed:
1. Assemble the complete `DESIGN.md` using the template above.
2. Show a summary: *"Here's the full DESIGN.md — {N} components, {M} page layouts, {K} user flows. Ready to write it to `{path}`?"*
3. Wait for confirmation.
4. Write the file using the Write tool.
5. Confirm: *"Done — `DESIGN.md` written to `{path}`."*

**If `FIGMA_MODE = active` — Optional Figma Scaffold:**

Follow the scaffold procedure in `references/figma-scaffold.md`. **Always ask for explicit confirmation before any write operation.**

**If `PAPER_MODE = active` — Optional Paper Scaffold:**

Follow the scaffold procedure in `references/paper-scaffold.md`. **Always ask for explicit confirmation before any write operation.**

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Design decisions** — color choices, typography selections, component patterns, layout approach, animation strategy
- **Explicit decisions** — choices the user made when you asked a clarifying question (e.g., CSS framework, dark mode inclusion, component variants)
- **Implicit decisions** — choices you made without asking because the spec was clear enough (e.g., inferring a component from an acceptance criterion, choosing a spacing scale)
- **Scope decisions** — omitting Dark Mode, deferring a COULD component's detailed design, including/excluding a section

### Additional exclusions

- Design Decisions already captured in the DESIGN.md's "Design Decisions & Rationale" section (avoid duplication)

For entry format, shared exclusions, and writing rules, see `references/decision-log-format.md`.

---

## Rules

1. **Traceable to the spec** — every component, layout, flow, and design choice must be grounded in the spec's user stories and functional scope. Do not invent UI elements not implied by the spec.
2. **Frontend only** — this skill produces design documents for features with user interfaces. If the spec does not describe a frontend feature, inform the user and suggest skipping to PLAN.
3. **Accessible by default** — all colors must meet WCAG 2.1 AA contrast ratios. All interactive elements must document keyboard and screen reader support.
4. **MoSCoW-aware depth** — MUST stories get full design treatment (all states, variants, wireframes). SHOULD stories get moderate treatment. COULD stories get minimal stubs. WON'T stories are never designed.
5. **No filler** — do not add design elements that are generic best practices not grounded in the spec. Every component and layout must serve a spec-derived purpose.
6. **English always** — write the DESIGN.md in English regardless of the language used in the conversation.
7. **Interactive and thorough** — scan the spec for gaps before writing. Ask all clarifying questions upfront in a single message, grouped by topic. Then propose each major section (Design System, Components, Page Layouts, User Flows, Interactions, Accessibility) as a draft and confirm with the user before moving on. Do not generate the full DESIGN in one shot without section-by-section confirmation.
8. **Benchmark-informed, not benchmark-bound** — if BENCHMARK.md visual references exist, use them as inspiration but never copy competitor layouts. Propose original designs informed by research.
9. **Concrete, not aspirational** — ASCII diagrams must show specific component placement. Color values must include hex codes. Typography must include specific sizes and weights. Avoid vague entries like "clean design" or "modern feel".
10. **Design tool is additive, never required** — Design tool MCP integration (Figma or Paper) enhances the skill but never blocks it. `DESIGN.md` is always the primary output. Scaffold and token sync are opt-in. If design tool calls fail or return errors mid-run, log the failure to `DECISION.md`, complete the `DESIGN.md` as normal, and inform the user: *"{Tool} scaffold failed at step {X}. DESIGN.md is complete — you can scaffold manually."*
11. **Design tool source of truth** — when `FIGMA_MODE = active` or `PAPER_MODE = active`, design-tool-sourced tokens always take precedence over codebase tokens for the same name. Conflicts must be resolved with the user before writing the Design System section.
12. **Experiment-aware design** — when a User Story has an `### Experimentation Strategy` block, design both the control experience and the variant experience. Label affected components and wireframes with `[Control: EXP-ID]` and `[Variant: EXP-ID]`. Both states need full design treatment: component states, accessibility, and responsive behavior. If the control is the existing behavior (no new design needed), only the variant needs a wireframe.

---

## Pipeline Iteration

Sometimes design work reveals that an upstream document needs revision. This section defines when to go back and how.

### When to Go Back

- **SPEC is missing UI requirements** — a user flow step has no corresponding component in the SPEC's functional scope, or the acceptance criteria don't cover a state the design needs (e.g., empty state, loading state). Ask the user: *"The design needs a {component/state} that isn't covered in the SPEC. Should I update the SPEC first?"*
- **Acceptance criteria conflict with accessibility requirements** — WCAG 2.1 AA contrast ratios or keyboard navigation requirements contradict specific SPEC instructions (e.g., a spec-mandated color choice fails contrast). Flag it: *"The SPEC specifies {X}, but WCAG AA requires {Y}. Should we update the SPEC's acceptance criteria?"*
- **Benchmark visual references reveal a SPEC functional scope gap** — competitor analysis from BENCHMARK.md shows a capability that the SPEC should cover but doesn't. Flag it: *"The benchmark shows competitors all support {X}, which the SPEC doesn't mention. Should the SPEC be updated?"*

For the universal rollback protocol (how to go back, what not to do, decision log format), see `references/pipeline-iteration.md`.

---

## Examples

### Example 1: Dashboard feature with existing design system
User says: "Design the analytics dashboard from the spec"
Actions:
1. Locate `docs/features/analytics-dashboard/SPEC.md`, read 3 MUST User Stories
2. Scan codebase — find `tailwind.config.ts` with existing color palette and spacing
3. Inform: "I found an existing design system in `tailwind.config.ts`. I'll extend it."
4. Design 6 components (Chart Card, Filter Bar, Date Picker, Data Table, KPI Tile, Export Button)
5. Draw 2 page layouts with ASCII wireframes (Dashboard Overview, Detailed Report)
6. Define 3 user flows (filter data, drill down, export report)
7. Write to `docs/features/analytics-dashboard/DESIGN.md`
Result: A DESIGN.md that extends the existing Tailwind design system with 6 new components, 2 layouts, and full accessibility specs

### Example 2: Greenfield feature, no existing design system
User says: "Create DESIGN.md from our onboarding spec"
Actions:
1. Locate the SPEC, scan codebase — no existing design system found
2. Ask: "No existing design system found. Any preferences? (Material-inspired, Shadcn-style, fully custom?)"
3. Propose a new color palette, typography scale, and spacing system from scratch
4. Design components, pages, and flows for each MUST and SHOULD story
5. Add COULD story components as stubs: "Detailed design deferred"
6. Write to `docs/features/onboarding/DESIGN.md`
Result: A DESIGN.md with a complete new design system and full component/layout coverage

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
