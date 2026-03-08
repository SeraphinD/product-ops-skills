---
name: brief-to-benchmark
description: Generates a BENCHMARK.md from a BRIEF.md — an optional research phase that grounds the upcoming SPEC in real-world data including comparable solutions, technical standards, key metrics, and gap analysis. Trigger on phrases like "benchmark the brief", "competitive analysis", "generate BENCHMARK.md", "benchmark phase", "research competitors for the feature", "market research before spec", "benchmark before writing specs", or when the user has a BRIEF.md and wants to validate against existing solutions or industry standards — even if they don't say "benchmark" explicitly. This is the optional second phase of the pipeline (BRIEF → BENCHMARK → SPEC → PLAN → TASKS). Do NOT use for creating a brief from scratch (use create-brief), converting a brief directly into specs (use brief-to-specs), or any other pipeline step.
allowed-tools: "Read Write Glob WebSearch WebFetch"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [benchmark, research, competitive-analysis, market-research]
---

# BRIEF → BENCHMARK Skill

This skill transforms a `BRIEF.md` into a `BENCHMARK.md` — a research artifact that grounds the upcoming SPEC in real-world data: comparable solutions, technical standards, key metrics, and gap analysis.

The benchmark phase is the **optional second phase** of the feature pipeline:

```
BRIEF.md → [BENCHMARK.md] → SPEC.md → PLAN.md → TASKS.md
```

Its purpose is to prevent the SPEC from being written in a vacuum — by researching what already exists before defining what to build. Users can skip this phase and go directly from BRIEF to SPEC. This skill exists for when they don't want to.

---

## Output Template

**After writing, run `bash scripts/validate-benchmark.sh {path-to-benchmark}` to verify structural completeness.**

The final `BENCHMARK.md` must follow **exactly** this structure:

```markdown
# Benchmark: {Feature Name}

> Generated from: {relative path to BRIEF.md}
> Date: {YYYY-MM-DD}

---

## Comparable Solutions

### {Competitor / Solution Name}
- **What it does:** {1–2 sentences}
- **Relevant approach:** {how it handles the problem your brief addresses}
- **Key differentiators:** {what makes it notable}
- **Gaps / weaknesses:** {where it falls short or doesn't apply}

{repeat for 3–5 comparable solutions}

---

## Technical Standards

- **{Standard or convention name}:** {what it specifies and why it's relevant}
- **{Library / framework convention}:** {common patterns in this domain}

{3–8 standards relevant to the feature}

---

## Key Metrics & Baselines

| Metric | Industry Baseline | Source / Notes |
|--------|------------------|----------------|
| {metric name} | {value or range} | {source, or "⚠️ Unverified — validate before use"} |

{3–6 metrics that will inform acceptance criteria in the SPEC}

---

## Gap Analysis

### What Existing Solutions Don't Cover
- {gap 1 — specific unmet need your brief addresses}
- {gap 2}

### What Your Brief Overlaps With
- {overlap 1 — where existing solutions already solve part of this}
- {overlap 2}

### Risks & Considerations
- {risk 1}
- {risk 2}

---

## Spec Recommendations

Based on the above research, the following should inform the SPEC:

- **Include:** {specific feature or behavior grounded in benchmarks}
- **Exclude (for now):** {scope boundary suggested by benchmark findings}
- **Validate before specifying:** {areas where more information is needed before writing ACs}

---

## Visual References *(frontend features only)*

### Competitor Layout Patterns

> These diagrams document existing solutions — they are references, not proposed designs.

#### {Competitor Name} — {Screen/Component Name}

```
{Unicode box-drawing diagram}
```

### User Flow Patterns

> Observed flow in {Competitor Name} — for reference only.

```mermaid
flowchart LR
  ...
```
```

---

## Interaction Protocol

Work section by section. For each section:
1. Share what you've researched or inferred
2. Propose a draft (including live research findings where available)
3. Ask for confirmation or adjustments before moving on
4. Mark any claim that couldn't be verified with `⚠️ Unverified — validate before use`

**Never generate the full BENCHMARK in one shot without confirming each section** with the user first.

---

## Step-by-Step Process

### Step 1 — Locate the BRIEF

Find the BRIEF.md. Look in this order:
1. The path the user provides directly
2. `docs/features/*/BRIEF.md` matching the feature name in context
3. Any `BRIEF.md` in the current working directory

Read the file in full. If no BRIEF is found, ask:
> "Which BRIEF.md should I use? I didn't find one in the current directory."

---

### Step 1.2 — Load Prior Decisions

Before generating anything, check whether a `DECISION.md` exists in the same `docs/features/{feature-name}/` directory as the BRIEF.

If it exists, read it in full. Then:
- **Treat every ✅ Accepted decision as a hard constraint** — do not re-open, re-ask, or contradict it.
- If a prior decision conflicts with benchmark findings, flag it: *"Decision {N} says X, but the research suggests Y. Which should take precedence?"*
- Do not log prior decisions again — only log new decisions made during this skill's execution.

---

### Step 1.5 — Detect Feature Type

Read the BRIEF and determine whether this is a **frontend feature** — one that involves UI, screens, pages, components, interactions, or visual design. Look for keywords like: UI, interface, page, component, screen, button, form, layout, design, dashboard, modal, flow, animation, visual.

- **Clearly frontend** → include the "Visual References" section in the output
- **Clearly backend / CLI / data pipeline** → omit it
- **Ambiguous** → ask: *"Is this a frontend feature? Should I include visual layout references for competitor UIs?"*

Log this decision to `DECISION.md`.

---

### Step 2 — Research Comparable Solutions

Search for 3–5 real-world solutions that address the same problem as the brief:

1. Use `WebSearch` with queries like `{feature domain} tools comparison`, `{problem} existing solutions`, `{tech stack} {feature} libraries`, `best {feature type} tools {year}`.
2. For each solution found, extract: what it does, how it approaches the problem, its differentiators, and its gaps relative to the brief.
3. Where a claim couldn't be verified from the search results, mark it: `⚠️ Unverified — validate before use`.

Propose each comparable solution as a draft entry. Confirm with the user before adding the next one. It's better to have 3 well-researched entries than 5 half-researched ones.

---

### Step 3 — Research Technical Standards

Search for established standards, conventions, and common patterns in the feature's domain:
- Protocols, specs, or RFCs (e.g., OAuth 2.0, WCAG 2.1, OpenAPI)
- Library or framework idioms (e.g., how React Query handles loading states, how Rails handles REST routing)
- Error handling norms, output format expectations, naming conventions

Use `WebSearch` where helpful. Flag anything unverified. Propose a draft list and confirm.

---

### Step 4 — Gather Key Metrics & Baselines

Identify 3–6 measurable metrics that will eventually inform acceptance criteria in the SPEC:
- Performance targets (load time, response time, throughput, bundle size)
- Quality thresholds (error rate, uptime, test coverage)
- UX benchmarks (time-on-task, success rate, accessibility score)

Research real baselines where possible. For every metric that couldn't be sourced from a credible reference, add `⚠️ Unverified — validate before use` in the Source column.

Propose the table as a draft. Confirm before continuing.

---

### Step 5 — Write the Gap Analysis

Synthesize findings from Steps 2–4 into three parts:

1. **What existing solutions don't cover** — the specific unmet need the brief addresses
2. **What the brief overlaps with** — where existing tools already solve part of the problem (important for scoping)
3. **Risks & considerations** — things that could affect the SPEC (e.g., hard-to-match metrics, patterns that don't scale)

Be analytical and honest. Overlaps aren't failures — they're useful scoping information.

Propose a draft. Confirm with the user.

---

### Step 6 — Write Spec Recommendations

Surface 3–8 concrete recommendations for the SPEC writer, grounded in benchmark findings:
- **Include** — features or behaviors supported by research
- **Exclude for now** — scope boundaries suggested by benchmarks (e.g., "competitors don't expose this via API, suggesting it's complex — consider deferring")
- **Validate before specifying** — areas where more information is needed before writing acceptance criteria

Frame these as *research-informed suggestions*, not requirements. The `brief-to-specs` skill makes final decisions.

Propose a draft. Confirm with the user.

---

### Step 7 — Visual References (frontend features only)

Skip this step entirely if the feature is not a frontend feature.

If it is a frontend feature:

**Unicode box-drawing diagrams** — draw simplified layout references for each comparable solution's relevant screen or component. Use `│`, `─`, `┌`, `┐`, `└`, `┘`, `├`, `┤`, `┬`, `┴`, `┼` for borders and structure. Label each element clearly inside the diagram. Always caption with: `> {Competitor Name} — {screen name} — reference only, not a proposed design.`

**Mermaid user flow diagrams** — document the user flow observed in comparable solutions using `flowchart LR` or `flowchart TD`. Label nodes with action descriptions matching the competitor's actual flow, not proposed feature names. Caption each diagram: `> Observed flow in {Competitor Name} — for reference only.`

Propose each diagram as a draft. Confirm before moving on.

---

### Step 8 — Determine Output Path

`BENCHMARK.md` is written to the **same directory as the source BRIEF** by default.

**Resolution logic:**
1. If the BRIEF is at `docs/features/my-feature/BRIEF.md`, write to `docs/features/my-feature/BENCHMARK.md`.
2. If the BRIEF is in the current working directory root, write `BENCHMARK.md` to the root.
3. If a `BENCHMARK.md` already exists at that path, ask the user before overwriting.
4. Never ask the user where to save — always derive the path. Inform the user before writing: *"I'll write the BENCHMARK to `docs/features/{feature-name}/BENCHMARK.md`."*

---

### Step 9 — Final Review & Write

Once all sections are confirmed:
1. Assemble the complete `BENCHMARK.md` using the template above.
2. Show a summary: *"Here's the full BENCHMARK.md — {N} comparable solutions, {K} metrics, {M} spec recommendations. Ready to write it to `{path}`?"*
3. Wait for confirmation.
4. Write the file using the Write tool.
5. Confirm: *"Done — `BENCHMARK.md` written to `{path}`."*

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Explicit decisions** — choices the user made when you asked (e.g., which competitors to include, whether to add visuals, which metrics to prioritize)
- **Implicit decisions** — choices you made without asking because the brief was clear enough (e.g., inferring this is a frontend feature, choosing 4 competitors over 3)
- **Functional decisions** — product-level choices that affect the SPEC (e.g., excluding a competitor as out of scope, flagging a metric as unverifiable)
- **Research decisions** — significant choices about what to research, what to include, and what to flag as unverified

### What NOT to log

- Mechanical actions (e.g., "ran a web search", "wrote the file")
- Formatting or template decisions already defined by this skill

### Entry format

```markdown
## Decision {N}: {Short title}
**Status:** ✅ Accepted
**Date:** {YYYY-MM-DD}
**Skill:** brief-to-benchmark

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

> For simple decisions (e.g., confirming a competitor inclusion), keep the entry lightweight — skip Options Considered and Consequences if they add no value. Use the full format for decisions that shape the benchmark's direction or affect downstream specs.

Append decisions to `DECISION.md` as they happen — do not batch at the end.

---

## Rules

1. **Grounded in research** — every comparable solution, standard, and metric must come from actual findings or be explicitly marked `⚠️ Unverified`. Never fabricate data.
2. **Traceable** — the `Generated from:` line must always reference the source BRIEF's relative path.
3. **Non-prescriptive** — the benchmark documents what *exists*, not what to build. Spec Recommendations is the only section that makes design suggestions, and they must be framed as research-informed suggestions, not requirements.
4. **Frontend visuals are references** — every Unicode or Mermaid diagram must be captioned as documenting an existing competitor. Never present them as proposed designs.
5. **Interactive and thorough** — confirm each section with the user before moving on. Never generate the full document in one shot.
6. **Confirm before writing** — always show a summary and ask before writing the file.
7. **English always** — write `BENCHMARK.md` in English regardless of the language used in the conversation.
8. **Unverified data is still useful** — include it, but flag it clearly with `⚠️`. A benchmark with honest gaps is more useful than an empty one.

---

## Examples

### Example 1: SaaS feature benchmark
User says: "Benchmark the brief for our notification system"
Actions:
1. Locate `docs/features/notification-system/BRIEF.md`, read it in full
2. Research 4 comparable solutions (e.g., OneSignal, Firebase Cloud Messaging, Pusher, Knock)
3. Identify 5 technical standards (WebSocket protocol, Push API, WCAG notification guidelines)
4. Gather 4 metrics with baselines (delivery rate, latency, opt-in rate, engagement rate)
5. Write gap analysis and spec recommendations
6. Write to `docs/features/notification-system/BENCHMARK.md`
Result: A BENCHMARK.md with 4 competitors, 5 standards, 4 metrics, and 6 spec recommendations — each section confirmed interactively

### Example 2: Frontend feature with visual references
User says: "Research competitors for our dashboard redesign"
Actions:
1. Locate the BRIEF, detect it's a frontend feature
2. Research comparable dashboards, include Unicode box-drawing layout diagrams for each
3. Add Mermaid user flow diagrams for key competitor workflows
4. Write the Visual References section with competitor UI patterns
Result: A BENCHMARK.md that includes both data research and visual competitor references

---

## Troubleshooting

### Problem: Web search returns no relevant results for comparable solutions
**Cause:** The feature domain is niche, or search queries are too specific.
**Solution:** Broaden search terms: try the problem domain rather than the feature name. Use queries like `{problem category} tools comparison` or `{industry} solutions for {pain point}`. If truly no comparables exist, note this honestly in the Comparable Solutions section and focus more on Technical Standards and Metrics.

### Problem: Metrics have no credible source
**Cause:** Industry baselines for the specific domain are not publicly available.
**Solution:** Mark with `⚠️ Unverified — validate before use` in the Source column. Include the metric anyway — an unverified baseline is more useful than no baseline. The spec writer can validate or discard it later.

### Problem: BRIEF.md not found
**Cause:** The file doesn't exist at the expected path, or the feature name doesn't match.
**Solution:** The skill will ask: "Which BRIEF.md should I use?" Provide the exact path. If the BRIEF hasn't been created yet, use the `create-brief` skill first.

### Problem: DECISION.md contains a decision that conflicts with benchmark findings
**Cause:** A prior decision may have been made before research was available.
**Solution:** Flag the conflict explicitly: "Decision {N} says X, but the research suggests Y. Which should take precedence?" Never silently override a logged decision.
