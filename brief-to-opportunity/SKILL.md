---
name: brief-to-opportunity
description: Scores a BRIEF.md using a customized RICE framework (Reach, Impact, Confidence, Effort) and produces an OPPORTUNITY.md score card for that feature. Impact is split into four dimensions (strategic, business, user, internal) scored on a Fibonacci scale. Trigger on phrases like "score this brief", "RICE score", "opportunity score", "prioritize this brief", "rank this feature", "generate OPPORTUNITY.md", "opportunity scoring", "score the brief", or when the user has a brief and wants to assess its priority — even if they don't say "RICE" explicitly. This is an optional step in the pipeline. Do NOT use for creating a brief (use create-brief), benchmarking (use brief-to-benchmark), converting a brief into specs (use brief-to-specs), or any other pipeline step.
allowed-tools: "Read Write Glob"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [rice, prioritization, opportunity, scoring]
---

# BRIEF → OPPORTUNITY Skill

This skill scores a `BRIEF.md` using a customized RICE framework and produces an `OPPORTUNITY.md` score card in the same feature directory.

The opportunity scoring phase is **optional** in the feature pipeline:

```
[PROBLEM FRAME] → BRIEF → [BENCHMARK] → [OPPORTUNITY] → SPEC → [DESIGN] → PLAN → TASKS
```

Its purpose is to produce a structured score card for a single brief. It does not compare briefs or maintain a ranking — if you need to compare multiple scored briefs, ask directly. This step is optional — you can skip it and go straight to SPEC.

---

## Scoring Framework

### RICE Formula

```
Impact = (w₁×Strategic + w₂×Business + w₃×User + w₄×Internal) / (w₁+w₂+w₃+w₄)
RICE = (Reach × Impact × Confidence) / Effort
```

Default weights: `w₁ = w₂ = w₃ = w₄ = 1` (equal weighting).

### Factor Scales

| Factor | Scale | Unit |
|--------|-------|------|
| **Reach** | 1–100 | % of user base affected per quarter |
| **Strategic Impact** | Fibonacci: 1, 2, 3, 5, 8, 13 | Alignment with vision, market positioning |
| **Business Impact** | Fibonacci: 1, 2, 3, 5, 8, 13 | Revenue, retention, conversion |
| **User Impact** | Fibonacci: 1, 2, 3, 5, 8, 13 | Pain relief, satisfaction, workflow improvement |
| **Internal Impact** | Fibonacci: 1, 2, 3, 5, 8, 13 | Team efficiency, tech debt reduction, operational cost |
| **Confidence** | 50%, 80%, 100% | How confident we are in the estimates |
| **Effort** | Fibonacci: 1, 2, 3, 5, 8, 13 | Person-weeks |

### Fibonacci Reference

| Value | Meaning |
|-------|---------|
| 1 | Negligible |
| 2 | Minor |
| 3 | Moderate |
| 5 | Significant |
| 8 | High |
| 13 | Transformative |

---

## Output Template

**After writing, run `bash scripts/validate-opportunity.sh {path-to-opportunity}` to verify structural completeness.**

The final `OPPORTUNITY.md` must follow **exactly** this structure:

```markdown
# Opportunity: {Feature Name}

> Generated from: {relative path to BRIEF.md}
> Method: RICE (Reach x Impact x Confidence / Effort)
> Impact weights: Strategic={w₁}, Business={w₂}, User={w₃}, Internal={w₄}
> Date: {YYYY-MM-DD}

---

## RICE Score: {score}

| Factor | Value | Rationale |
|--------|-------|-----------|
| Reach | {value}% of users | {why this percentage} |
| Strategic Impact | {1-13} | {rationale} |
| Business Impact | {1-13} | {rationale} |
| User Impact | {1-13} | {rationale} |
| Internal Impact | {1-13} | {rationale} |
| **Impact (weighted avg)** | **{value}** | weights: {w₁}/{w₂}/{w₃}/{w₄} |
| Confidence | {50/80/100}% | {rationale} |
| Effort | {1-13} person-weeks | {rationale} |
```

---

## Interaction Protocol

Work factor by factor. For each RICE factor:
1. Share what the brief (and benchmark, if available) suggests about this factor
2. Propose a score with a one-sentence rationale
3. Ask for confirmation or adjustment before moving on

**Never assign all scores at once without confirming each factor** with the user first.

---

## Step-by-Step Process

### Step 1 — Locate the BRIEF

Find the BRIEF.md. Look in this order:
1. The path the user provides directly
2. `docs/features/*/BRIEF.md` matching the feature name in context
3. Any `BRIEF.md` in the current working directory

Read the file in full. If no BRIEF is found, ask:
> "Which BRIEF.md should I score? I didn't find one in the current directory."

---

### Step 2 — Load Supporting Artifacts

After reading the BRIEF, check the same `docs/features/{feature-name}/` directory for:

- **`BENCHMARK.md`** — if it exists, read it. Use comparable solutions, metrics, and gap analysis to inform Reach, Confidence, and Impact scores. Verified metrics increase Confidence; gaps inform Strategic and User Impact.
- **`DECISION.md`** — if it exists, read it. Treat all ✅ Accepted decisions as context. Do not re-open them.

Inform the user what was found:
> "I found a BENCHMARK.md — I'll use the competitive data to calibrate the scores."

or:
> "No BENCHMARK.md found — I'll score based on the brief alone."

---

### Step 3 — Assess Reach

**Question:** What percentage of the user base will this feature affect per quarter?

Read the brief's Problem Statement and Scope to infer who is affected. If a BENCHMARK exists, check Key Metrics for user-base data.

Propose a percentage with rationale. Ask:
> "I estimate this reaches about {X}% of users per quarter because {reason}. Does that sound right?"

Confirm before continuing.

---

### Step 4 — Assess Strategic Impact

**Question:** How well does this feature align with company vision and market positioning?

Look for signals in the brief's Executive Summary and Key Objectives. Consider:
- Does it open a new market or segment?
- Does it strengthen competitive positioning?
- Is it aligned with the company's stated direction?

Propose a Fibonacci score (1–13) with rationale. Confirm.

---

### Step 5 — Assess Business Impact

**Question:** What is the expected effect on revenue, retention, or conversion?

Look for signals in the brief's Key Objectives and Success Criteria. If a BENCHMARK exists, check Key Metrics for business baselines.

Propose a Fibonacci score (1–13) with rationale. Confirm.

---

### Step 6 — Assess User Impact

**Question:** How much pain does this relieve or how much does it improve the user's workflow?

Look for signals in the brief's Problem Statement (pain points) and Solution. If a BENCHMARK exists, check Gap Analysis for unmet needs.

Propose a Fibonacci score (1–13) with rationale. Confirm.

---

### Step 7 — Assess Internal Impact

**Question:** How much does this improve team efficiency, reduce tech debt, or lower operational cost?

Look for signals in the brief's Key Objectives and Assumptions & Risks. Not every feature has internal impact — a score of 1 is valid.

Propose a Fibonacci score (1–13) with rationale. Confirm.

---

### Step 8 — Assess Confidence

**Question:** How confident are we in the estimates above?

Three levels:
- **100% (High)** — backed by data, benchmarks, user research, or validated metrics
- **80% (Medium)** — some evidence, reasonable assumptions, partial data
- **50% (Low)** — gut feeling, limited data, high uncertainty

If a `BENCHMARK.md` exists with verified (non-⚠️) metrics, that supports higher confidence. If most claims are unverified or the brief has many untested assumptions, confidence is lower.

Propose a level with rationale. Confirm.

---

### Step 9 — Assess Effort

**Question:** How many person-weeks will this take to build, using the Fibonacci scale?

Read the brief's Scope (In Scope items) and Assumptions & Risks to estimate complexity. Consider:
- Number of in-scope deliverables
- Technical risks mentioned
- Dependencies on external systems

Propose a Fibonacci score (1–13) with rationale. Confirm.

---

### Step 10 — Compute & Confirm

Calculate the RICE score:

```
Impact = (w₁×Strategic + w₂×Business + w₃×User + w₄×Internal) / (w₁+w₂+w₃+w₄)
RICE = (Reach × Impact × Confidence) / Effort
```

Round Impact to one decimal place. Round RICE to the nearest integer.

Show the complete score card to the user:

> **{Feature Name} — RICE Score: {score}**
>
> | Factor | Value | Rationale |
> |--------|-------|-----------|
> | Reach | {X}% | ... |
> | Strategic Impact | {N} | ... |
> | Business Impact | {N} | ... |
> | User Impact | {N} | ... |
> | Internal Impact | {N} | ... |
> | **Impact (weighted avg)** | **{N.N}** | weights: 1/1/1/1 |
> | Confidence | {N}% | ... |
> | Effort | {N} person-weeks | ... |

Ask: *"Does this score card look right? Ready to write it to OPPORTUNITY.md?"*

---

### Step 11 — Determine Output Path & Write

`OPPORTUNITY.md` is written to the **same directory as the source BRIEF** by default.

**Resolution logic:**
1. If the BRIEF is at `docs/features/my-feature/BRIEF.md`, write to `docs/features/my-feature/OPPORTUNITY.md`.
2. If the BRIEF is in the current working directory root, write `OPPORTUNITY.md` to the root.
3. If an `OPPORTUNITY.md` already exists at that path, ask the user before overwriting.
4. Never ask the user where to save — always derive the path. Inform the user before writing: *"I'll write the OPPORTUNITY to `docs/features/{feature-name}/OPPORTUNITY.md`."*

Write the file. Confirm:
> "Done — `OPPORTUNITY.md` written to `{path}`. RICE score: {score}."

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Score justifications** — when the user overrides a proposed score, log the original proposal, the user's chosen value, and the rationale
- **Confidence adjustments** — when benchmark data changes the confidence level
- **Weight changes** — if the user adjusts impact weights from the default

### What NOT to log

- Mechanical actions (e.g., "wrote the file")
- Default weight usage (only log if weights are changed)

### Entry format

```markdown
## Decision {N}: {Short title}
**Status:** ✅ Accepted
**Date:** {YYYY-MM-DD}
**Skill:** brief-to-opportunity

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

> For simple score confirmations, keep the entry lightweight — skip Options Considered and Consequences. Use the full format for decisions that change weights or override multiple scores.

Append decisions to `DECISION.md` as they happen — do not batch at the end.

---

## Rules

1. **One brief, one score card** — each invocation scores a single brief and writes one OPPORTUNITY.md to that feature's directory.
2. **Interactive scoring** — confirm each RICE factor with the user before moving on. Never assign all scores silently.
3. **Fibonacci only** — Impact and Effort scores must be valid Fibonacci values: 1, 2, 3, 5, 8, 13. If the user proposes a non-Fibonacci value, suggest the nearest Fibonacci values and ask them to pick.
4. **Benchmark-informed** — when a BENCHMARK.md exists, use its data to calibrate scores. Cite specific findings when proposing a score.
5. **Honest confidence** — do not inflate confidence. If most estimates are gut-based, confidence is 50%. Having a BENCHMARK with verified data is one of the few things that justifies 100%.
6. **Confirm before writing** — always show the full score card and ask before writing the file.
7. **English always** — write OPPORTUNITY.md in English regardless of the language used in the conversation.

---

## Examples

### Example 1: Brief with benchmark data
User says: "Score the push notifications brief"
Actions:
1. Locate `docs/features/push-notifications/BRIEF.md`, read it
2. Find `BENCHMARK.md` in same directory — read it for calibration
3. Walk through each factor: Reach (60%), Strategic (5), Business (8), User (8), Internal (2), Confidence (80%), Effort (8)
4. Compute: Impact = (5+8+8+2)/4 = 5.8, RICE = (60 × 5.8 × 80) / 8 = 3480
5. Write to `docs/features/push-notifications/OPPORTUNITY.md`
Result: Score card with RICE 3480, confidence at 80% thanks to benchmark data

### Example 2: Brief without benchmark
User says: "RICE score for dark mode"
Actions:
1. Locate `docs/features/dark-mode/BRIEF.md`, read it
2. No BENCHMARK.md found — score from brief alone
3. Walk through each factor: Reach (80%), Strategic (3), Business (3), User (5), Internal (1), Confidence (50%), Effort (3)
4. Compute: Impact = (3+3+5+1)/4 = 3.0, RICE = (80 × 3.0 × 50) / 3 = 4000
5. Write to `docs/features/dark-mode/OPPORTUNITY.md`
Result: Score card with RICE 4000, confidence at 50% due to no benchmark data

### Example 3: OPPORTUNITY.md already exists
User says: "Re-score the push notifications brief"
Actions:
1. Locate the brief, find existing `OPPORTUNITY.md` in same directory
2. Ask: "An OPPORTUNITY.md already exists for push notifications (RICE: 3480). Do you want to overwrite it?"
3. If yes, walk through factors again and replace the file
4. If no, stop
Result: Updated score card replaces the old one

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
