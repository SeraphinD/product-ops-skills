---
name: brief-to-benchmark
description: Use when a BRIEF.md exists and the user wants to research comparable solutions, industry standards, or competitive landscape before writing a SPEC — triggered by phrases like "benchmark the brief", "competitive analysis", "research competitors", "market research before spec", or when the user supplies their own research data to structure into a benchmark. Do NOT use for creating a brief (use create-brief) or converting a brief to specs (use brief-to-specs).
allowed-tools: "Read Write Glob WebSearch WebFetch"
license: MIT
metadata:
  author: seraphindesumeur
  version: 2.0.0
  category: feature-pipeline
  tags: [benchmark, research, competitive-analysis, market-research, custom-benchmark, market-scoping]
---

# BRIEF → BENCHMARK Skill

This skill transforms a `BRIEF.md` into a `BENCHMARK.md` — a research artifact that grounds the upcoming SPEC in real-world data: comparable solutions, technical standards, key metrics, and gap analysis.

The benchmark phase is the **optional second phase** of the feature pipeline:

```
BRIEF.md → [BENCHMARK.md] → SPEC.md → PLAN.md → TASKS.md
```

Its purpose is to prevent the SPEC from being written in a vacuum — by researching what already exists before defining what to build. Users can skip this phase and go directly from BRIEF to SPEC. This skill exists for when they don't want to.

The skill supports three **benchmark modes**:
- **Auto** — the agent researches everything via `WebSearch` (default)
- **Provided** — the user supplies their own benchmark data (files, links, raw notes, competitor names)
- **Hybrid** — the user supplies partial data, the agent fills gaps with web research

It also supports **custom benchmark types** (compliance, user research, internal performance, market analysis) and **market/domain scoping** to focus research on a specific geography or industry vertical.

---

## When to Use

**Use this skill when:**
- A `BRIEF.md` exists and the user wants to research the landscape before writing a SPEC
- The user asks for competitive analysis, comparable solutions, or industry benchmarks
- The user has their own research data (competitors, metrics, standards) and wants it structured into a benchmark
- The user wants a compliance, market, or user-research benchmark variant

**Do NOT use when:**
- No BRIEF exists yet → use `create-brief`
- The user wants to skip research and go straight to specs → use `brief-to-specs`
- The user wants to score/prioritize a brief → use `brief-to-opportunity`
- The user wants to create a problem frame → use `create-problem-frame`

---

## Quick Reference

| Step | Action | Applies to |
|------|--------|------------|
| 1 | Locate the BRIEF | All modes |
| 2 | Load prior decisions from DECISION.md | All modes |
| 3 | Determine benchmark mode (auto/provided/hybrid) and custom type | All modes |
| 4 | Scope market and domain | All modes (adaptive to mode) |
| 5 | Detect feature type (frontend vs backend) | All modes |
| 6 | Comparable Solutions (or custom replacement section) | Auto / Provided / Hybrid |
| 7 | Technical Standards (or custom addition) | Auto / Provided / Hybrid |
| 8 | Key Metrics & Baselines (or custom addition) | Auto / Provided / Hybrid |
| 9 | Gap Analysis | All modes |
| 10 | Spec Recommendations | All modes |
| 11 | Visual References | Frontend features only |
| 12 | Determine output path | All modes |
| 13 | Final review and write | All modes |

---

## Common Mistakes

- **Fabricating competitor data** — when WebSearch returns nothing, flag gaps with `⚠️ Unverified` or note the absence honestly. Never invent competitors or metrics.
- **Skipping market/domain scoping** — even when it feels redundant, scoping focuses research queries and prevents generic results. At minimum, tag the benchmark with the scope context.
- **Generating the full BENCHMARK in one shot** — always confirm each section individually. The user may have corrections, additions, or want to steer the research direction.
- **Heavyweight decision logging for trivial decisions** — use the lightweight format for binary choices (frontend vs backend, market: EU, mode: auto). Reserve the full format for decisions that shape the benchmark.
- **Unreliable ASCII art** — Unicode box-drawing diagrams are error-prone. Prefer Mermaid diagrams or structured layout descriptions when representing competitor UIs.
- **Writing in the conversation language** — `BENCHMARK.md` must always be in English, regardless of the language used in the conversation.

---

## Output Template

**Before writing any output, read `references/template.md` for the exact BENCHMARK.md structure.**

The BENCHMARK contains: Comparable Solutions (3–5 entries), Technical Standards, Key Metrics & Baselines, Gap Analysis, Spec Recommendations, an optional Visual References section for frontend features, and optional custom sections when using a non-standard benchmark type.

**After writing, run `bash scripts/validate-benchmark.sh {path-to-benchmark}` to verify structural completeness. For custom benchmark types, use `bash scripts/validate-benchmark.sh {path-to-benchmark} --custom` to relax data-section checks.**

---

## Interaction Protocol

**Always write `BENCHMARK.md` in English** regardless of the language used in the conversation.

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

### Step 2 — Load Prior Decisions

Before generating anything, check whether a `DECISION.md` exists in the same `docs/features/{feature-name}/` directory as the BRIEF.

If it exists, read it in full. Then:
- **Treat every ✅ Accepted decision as a hard constraint** — do not re-open, re-ask, or contradict it.
- If a prior decision conflicts with benchmark findings, flag it: *"Decision {N} says X, but the research suggests Y. Which should take precedence?"*
- Do not log prior decisions again — only log new decisions made during this skill's execution.

---

### Step 3 — Determine Benchmark Mode

Before starting research, determine how the benchmark data will be sourced and whether a non-standard benchmark type is needed.

**1. Detect data inputs:**
Check if the user provided data alongside the benchmark request — files, links, raw text, competitor names, spreadsheets, or references. Look for phrases like "use this data", "here's my research", "benchmark with these competitors", "I have metrics from...", or attached file paths.

**2. Detect custom benchmark type:**
Check if the user requested a non-standard benchmark category. Map known types to section changes:

| User says | Section changes |
|-----------|----------------|
| "user research benchmark" | Replace Comparable Solutions with **User Research Findings** (personas, pain points, quotes) |
| "compliance benchmark" | Add **Regulatory Requirements** section (regulations, compliance gaps, certification needs) |
| "internal performance benchmark" | Add **Current System Baselines** section (existing metrics from the user's own product) |
| "market benchmark" | Add **Market Sizing** and **Pricing Analysis** sections |
| unknown type | Ask: *"What sections should this benchmark include?"* |

Gap Analysis and Spec Recommendations are **always required** regardless of benchmark type — they are the bridge to the SPEC. Custom types add to or replace the data-gathering sections (Comparable Solutions, Technical Standards, Key Metrics).

**3. Confirm mode:**
Based on what's detected, ask to confirm:
> "I see you've provided {description of inputs}. Should I: (a) use only your data, (b) use your data and supplement with web research, or (c) ignore your data and research from scratch?"

- **Auto mode** (no user-provided data) → proceed with the standard WebSearch-driven flow
- **Provided mode** (user supplied all data) → skip WebSearch, structure the user's data into the BENCHMARK template, fill gaps by asking the user
- **Hybrid mode** (user supplied partial data) → use provided data as-is, research only the missing sections via WebSearch

If no data was provided and no custom type was requested, default to **Auto mode** without asking.

Log the mode and benchmark type decisions to `DECISION.md`.

---

### Step 4 — Scope the Benchmark (Market & Domain)

Adapt scoping questions to the benchmark mode determined in Step 3.

**Auto / Hybrid mode — ask two scoping questions:**

**1. Market focus:**
> "Which market(s) should this benchmark focus on? Examples: EU, US, APAC, global, or a specific country. This affects which competitors, regulations, and standards I'll prioritize."

**2. Domain focus:**
> "Which domain or industry vertical should I focus on? Examples: fashion, home furniture, sport, fintech, healthcare, food & beverage, SaaS — or leave open if the feature is domain-agnostic."

**Provided mode — ask for tagging context only:**
> "What market and domain context should I tag this benchmark with? This won't affect research (since we're using your data), but it labels the output for downstream use."

**Handling responses:**
- If the user specifies both → use them as primary filters for all research queries (Auto/Hybrid) or as metadata tags (Provided) and flag findings that are market- or domain-specific
- If the user specifies only one → ask if the other should be left open or narrowed
- If the user says "no preference" or "global" → proceed without filters, but still tag competitor entries with their primary market/domain for context
- If the BRIEF already contains market or domain context → propose it: *"The brief mentions {X}. Should I scope the benchmark to that, or broaden it?"*

**How scope affects downstream steps (Auto/Hybrid only):**
- **Comparable Solutions** — search queries include the market/domain (e.g., `fashion e-commerce notification tools EU` instead of just `notification tools`)
- **Technical Standards** — prioritize region-specific regulations (e.g., GDPR for EU, CCPA for US, PSD2 for EU fintech) and domain-specific standards
- **Key Metrics** — source baselines from the relevant market/domain (e.g., EU fashion e-commerce conversion rates, not global SaaS averages)
- **Gap Analysis** — frame gaps relative to the scoped market/domain, not the global landscape

**Fast-track path:** If all of these are true — Auto mode, standard benchmark type, no market/domain constraints (user says "global" or "no preference") — skip the remaining scoping questions and proceed directly to Step 5 with a single confirmation: *"I'll run a standard global benchmark in auto mode. Good to proceed?"*

Log the market and domain decisions to `DECISION.md`.

---

### Step 5 — Detect Feature Type

Read the BRIEF and determine whether this is a **frontend feature** — one that involves UI, screens, pages, components, interactions, or visual design. Look for keywords like: UI, interface, page, component, screen, button, form, layout, design, dashboard, modal, flow, animation, visual.

- **Clearly frontend** → include the "Visual References" section in the output
- **Clearly backend / CLI / data pipeline** → omit it
- **Ambiguous** → ask: *"Is this a frontend feature? Should I include visual layout references for competitor UIs?"*

Log this decision to `DECISION.md`.

---

### Step 6 — Comparable Solutions

*If using a custom benchmark type that replaces this section (e.g., "user research benchmark" → User Research Findings), skip this step and produce the replacement section instead, following the same interactive protocol: propose a draft entry, confirm, repeat.*

**Auto mode:**
Search for 3–5 real-world solutions that address the same problem as the brief:

1. Use `WebSearch` with queries that include the market/domain scope from Step 4 — e.g., `{domain} {market} {feature domain} tools comparison`, `{problem} existing solutions {market}`, `best {feature type} tools {domain} {year}`.
2. For each solution found, extract: what it does, how it approaches the problem, its differentiators, and its gaps relative to the brief.
3. Where a claim couldn't be verified from the search results, mark it: `⚠️ Unverified — validate before use`.
4. Where observable, note whether the competitor uses A/B testing, feature flags, or gradual rollouts for this feature area — this context informs the SPEC's experimentation strategy.

**Provided mode:**
Structure the user's provided competitors into the template format. For each entry:
1. Extract: what it does, relevant approach, differentiators, gaps — from the data the user supplied
2. If the user's data is incomplete for an entry, ask for the missing fields rather than researching silently
3. Do not use `WebSearch` — rely entirely on user-provided data

**Hybrid mode:**
Use provided competitor data first, then supplement:
1. Structure user-provided competitors as in Provided mode
2. If fewer than 3 solutions were provided, use `WebSearch` (with market/domain filters) to find additional ones
3. For user-provided entries with incomplete data, ask the user first; only research if they prefer

Propose each comparable solution as a draft entry. Confirm with the user before adding the next one. It's better to have 3 well-researched entries than 5 half-researched ones.

*If search returns no relevant results, see `references/troubleshooting.md` — "Web search returns no relevant results for comparable solutions".*

---

### Step 7 — Technical Standards

*If using a custom benchmark type that adds a section here (e.g., "compliance benchmark" → Regulatory Requirements), produce that section in addition to or instead of technical standards, as agreed in Step 3.*

**Auto mode:**
Search for established standards, conventions, and common patterns in the feature's domain:
- Protocols, specs, or RFCs (e.g., OAuth 2.0, WCAG 2.1, OpenAPI)
- Library or framework idioms (e.g., how React Query handles loading states, how Rails handles REST routing)
- Region-specific regulations relevant to the market scope from Step 4 (e.g., GDPR for EU, CCPA for US, PSD2 for EU fintech)
- Domain-specific standards relevant to the domain scope from Step 4
- Error handling norms, output format expectations, naming conventions

Use `WebSearch` with market/domain filters where helpful. Flag anything unverified.

**Provided mode:**
Structure the user's provided standards, regulations, or conventions into the template format. Ask for clarifications if entries are incomplete. Do not use `WebSearch`.

**Hybrid mode:**
Use provided standards first. If the list has fewer than 3 entries or obvious gaps (e.g., no region-specific regulations for a scoped market), supplement with `WebSearch` using market/domain filters.

Propose a draft list and confirm.

*If no credible standards are found, see `references/troubleshooting.md` — "Web search returns no relevant results for comparable solutions" (same broadening strategy applies).*

---

### Step 8 — Key Metrics & Baselines

*If using a custom benchmark type that adds a section here (e.g., "internal performance benchmark" → Current System Baselines, or "market benchmark" → Market Sizing + Pricing Analysis), produce those sections in addition to or instead of key metrics, as agreed in Step 3.*

**Auto mode:**
Identify 3–6 measurable metrics that will eventually inform acceptance criteria in the SPEC:
- Performance targets (load time, response time, throughput, bundle size)
- Quality thresholds (error rate, uptime, test coverage)
- UX benchmarks (time-on-task, success rate, accessibility score)

Source baselines from the relevant market/domain when possible (e.g., EU fashion e-commerce conversion rates, not global SaaS averages). For every metric that couldn't be sourced from a credible reference, add `⚠️ Unverified — validate before use` in the Source column.

**Provided mode:**
Structure the user's provided metrics and baselines into the template table format. If baselines are missing for a metric, ask the user rather than researching. Do not use `WebSearch`.

**Hybrid mode:**
Use provided metrics first. If fewer than 3 metrics were provided, or if provided metrics lack baselines, supplement with `WebSearch` using market/domain filters to find credible sources.

Propose the table as a draft. Confirm before continuing.

*If metrics have no credible source, see `references/troubleshooting.md` — "Metrics have no credible source".*

---

### Step 9 — Write the Gap Analysis

Synthesize findings from Steps 6–8 into three parts:

1. **What existing solutions don't cover** — the specific unmet need the brief addresses
2. **What the brief overlaps with** — where existing tools already solve part of the problem (important for scoping)
3. **Risks & considerations** — things that could affect the SPEC (e.g., hard-to-match metrics, patterns that don't scale)

**If the BRIEF has an Assumptions & Risks section:** Check each listed assumption against the research findings. If the benchmark data validates an assumption, note it. If the research contradicts an assumption, flag it explicitly in Risks & Considerations: *"The brief assumes X, but benchmark research suggests Y."* This is one of the highest-value outputs of the benchmark phase — catching bad assumptions before they reach the SPEC.

Be analytical and honest. Overlaps aren't failures — they're useful scoping information.

Propose a draft. Confirm with the user.

---

### Step 10 — Write Spec Recommendations

Surface 3–8 concrete recommendations for the SPEC writer, grounded in benchmark findings:
- **Include** — features or behaviors supported by research
- **Exclude for now** — scope boundaries suggested by benchmarks (e.g., "competitors don't expose this via API, suggesting it's complex — consider deferring")
- **Validate before specifying** — areas where more information is needed before writing acceptance criteria
- **Test before full rollout** — features where competitors A/B test, where benchmark data shows high behavioral variance, or where the brief's success criteria contain unvalidated behavioral hypotheses

Frame these as *research-informed suggestions*, not requirements. The `brief-to-specs` skill makes final decisions.

Propose a draft. Confirm with the user.

---

### Step 11 — Visual References (frontend features only)

Skip this step entirely if the feature is not a frontend feature.

If it is a frontend feature:

**Mermaid user flow diagrams (primary)** — document the user flow observed in comparable solutions using `flowchart LR` or `flowchart TD`. Label nodes with action descriptions matching the competitor's actual flow, not proposed feature names. Caption each diagram: `> Observed flow in {Competitor Name} — for reference only.`

**Structured layout descriptions (recommended for layouts)** — for each comparable solution's relevant screen or component, describe the layout as a structured bulleted list: top-level regions (header, sidebar, main, footer), key elements within each region, and notable interaction patterns. Caption with: `> {Competitor Name} — {screen name} — reference only, not a proposed design.`

**Unicode box-drawing diagrams (optional)** — only attempt these if the layout is simple enough to represent accurately with box-drawing characters (`│`, `─`, `┌`, `┐`, `└`, `┘`). Complex layouts should use structured descriptions instead, as Unicode diagrams are error-prone.

Propose each diagram or description as a draft. Confirm before moving on.

---

### Step 12 — Determine Output Path

`BENCHMARK.md` is written to the **same directory as the source BRIEF** by default.

**Resolution logic:**
1. If the BRIEF is at `docs/features/my-feature/BRIEF.md`, write to `docs/features/my-feature/BENCHMARK.md`.
2. If the BRIEF is in the current working directory root, write `BENCHMARK.md` to the root.
3. If a `BENCHMARK.md` already exists at that path, ask the user before overwriting.
4. Never ask the user where to save — always derive the path. Inform the user before writing: *"I'll write the BENCHMARK to `docs/features/{feature-name}/BENCHMARK.md`."*

---

### Step 13 — Final Review & Write

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

**Format heuristic:** Use the lightweight format for binary or simple decisions (e.g., frontend vs backend, market: EU, mode: auto). Use the full format for decisions that shape the benchmark's direction (e.g., excluding a major competitor, broadening scope after failed search, overriding a prior decision).

For entry format, shared exclusions, and writing rules, see `references/decision-log-format.md`.

---

## Rules

1. **Grounded in evidence** — every comparable solution, standard, and metric must come from actual research findings or user-provided data, or be explicitly marked `⚠️ Unverified`. Never fabricate data. In Provided mode, treat user-supplied data as the source of truth.
2. **Traceable** — the `Generated from:` line must always reference the source BRIEF's relative path.
3. **Non-prescriptive** — the benchmark documents what *exists*, not what to build. Spec Recommendations is the only section that makes design suggestions, and they must be framed as research-informed suggestions, not requirements.
4. **Frontend visuals are references** — every Unicode or Mermaid diagram must be captioned as documenting an existing competitor. Never present them as proposed designs.
5. **Interactive and thorough** — confirm each section with the user before moving on. Never generate the full document in one shot.
6. **Confirm before writing** — always show a summary and ask before writing the file.
7. **Unverified data is still useful** — include it, but flag it clearly with `⚠️`. A benchmark with honest gaps is more useful than an empty one.

---

## Pipeline Iteration

Sometimes benchmark research reveals that an upstream document needs revision. This section defines when to go back and how.

### When to Go Back

- **Research contradicts the BRIEF's problem statement or assumptions** — comparable solutions or technical standards show that a core assumption in the BRIEF is wrong. Flag it to the user: *"The benchmark research suggests {X}, but the BRIEF assumes {Y}. Should I update the BRIEF before continuing?"*
- **A comparable solution was missed that changes the gap analysis** — the user or a later review identifies a competitor that should have been included. Re-open Step 6 (Comparable Solutions) and revise the Gap Analysis.
- **Technical standards research reveals the BRIEF's solution approach is infeasible** — a regulation, protocol, or industry convention makes the proposed approach untenable. Flag it and suggest updating the BRIEF's Solution section.

For the universal rollback protocol (how to go back, what not to do, decision log format), see `references/pipeline-iteration.md`.

---

## Examples

### Example 1: SaaS feature benchmark (auto mode)
User says: "Benchmark the brief for our notification system"
Actions:
1. Locate `docs/features/notification-system/BRIEF.md`, read it in full
2. Default to Auto mode (no data provided)
3. Ask market/domain scope → user says "Global, SaaS"
4. Research 4 comparable solutions (e.g., OneSignal, Firebase Cloud Messaging, Pusher, Knock)
5. Identify 5 technical standards (WebSocket protocol, Push API, WCAG notification guidelines)
6. Gather 4 metrics with baselines (delivery rate, latency, opt-in rate, engagement rate)
7. Write gap analysis and spec recommendations
8. Write to `docs/features/notification-system/BENCHMARK.md`
Result: A BENCHMARK.md with 4 competitors, 5 standards, 4 metrics, and 6 spec recommendations — each section confirmed interactively

### Example 2: Frontend feature with visual references
User says: "Research competitors for our dashboard redesign"
Actions:
1. Locate the BRIEF, detect it's a frontend feature
2. Default to Auto mode, ask market/domain scope → user says "US, e-commerce"
3. Research comparable dashboards, include Mermaid user flow diagrams and structured layout descriptions
4. Write the Visual References section with competitor UI patterns
5. Write gap analysis and spec recommendations
Result: A BENCHMARK.md that includes both data research and visual competitor references, scoped to US e-commerce

### Example 3: User-provided benchmark data (provided mode)
User says: "Benchmark the brief — here are the competitors I've already researched: Shopify, Magento, WooCommerce. I also have conversion rate data in my notes."
Actions:
1. Locate the BRIEF, read it in full
2. Detect provided data (3 competitors + metrics), confirm Provided mode
3. Ask market/domain tagging context → user says "EU, fashion e-commerce"
4. Structure the 3 competitors into the Comparable Solutions template, ask for missing fields (gaps, differentiators)
5. Structure user's conversion rate data into Key Metrics table, ask for any missing baselines
6. Research Technical Standards via user input only — ask what standards apply
7. Write gap analysis and spec recommendations grounded in user-provided data
8. Write to the feature directory
Result: A BENCHMARK.md built entirely from user-supplied data, with no web research — scoped to EU fashion

### Example 4: Market/domain-scoped hybrid benchmark
User says: "Benchmark the brief for our product catalog — focus on the EU home furniture market. I know about IKEA and Maisons du Monde, but research the rest."
Actions:
1. Locate the BRIEF, read it in full
2. Detect partial data (2 competitors), confirm Hybrid mode
3. Market: EU, Domain: home furniture (user-specified)
4. Structure IKEA and Maisons du Monde from user data, then WebSearch for 1–2 more EU home furniture competitors
5. Research EU-specific technical standards (e.g., EU Ecodesign Directive, GDPR, PSD2) and domain conventions
6. Source metrics from EU home furniture e-commerce baselines
7. Write gap analysis and spec recommendations
8. Write to the feature directory
Result: A BENCHMARK.md combining user knowledge with web research, tightly scoped to EU home furniture

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
