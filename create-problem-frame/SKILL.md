---
name: create-problem-frame
description: Interactively creates a PROBLEM-FRAME.md that forces clarity on what the actual problem is before anyone jumps to solutions. Walks the user through structured Q&A covering situation context, problem articulation, adaptive root cause analysis (5 Whys), constraints, success definition, and alternative framings. This is the first step in the discovery pipeline — it feeds into create-brief. Trigger on phrases like "frame a problem", "create a problem frame", "problem framing", "generate PROBLEM-FRAME.md", "what problem are we solving", "define the problem", "let's clarify the problem", "start with the problem", "root cause analysis", or "5 whys". Do NOT use for creating a brief (use create-brief), converting a brief into specs (use brief-to-specs), benchmarking (use brief-to-benchmark), or any downstream pipeline step — this skill defines and validates the problem only.
allowed-tools: "Read Write Glob"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [problem-framing, discovery, root-cause, five-whys, pipeline]
---

# Create Problem Frame Skill

This skill interactively generates a `PROBLEM-FRAME.md` file by guiding the user through a structured problem definition process. The goal is to ensure the problem is clearly articulated, root-caused, and stress-tested before anyone writes a brief or commits to a solution.

A well-framed problem prevents the most expensive failure mode in product development: building the right solution to the wrong problem.

## Output Location

The file is **always** written to:

```
docs/features/{feature-name}/PROBLEM-FRAME.md
```

Where `{feature-name}` is the kebab-case version of the working title confirmed during the interaction.

Before writing, read `references/template.md` for the exact output structure.

## Interaction Protocol

Work section by section. For each section:
1. Share what you know or have inferred from context
2. Ask only what is genuinely missing or ambiguous
3. Propose a draft and ask for confirmation before moving on
4. Never fill a section with vague or generic content — ask instead

**Never skip a section.** If the user hasn't provided enough to write a section confidently, ask a targeted question.

---

## Step-by-Step Process

### Step 0 — Initial Context Gathering

Start by asking the user to describe the situation in their own words. One open question is enough:

> "Describe the problem or situation you want to frame — what's happening, who's affected, and what made you notice it."

From their answer, extract what you can. Identify gaps before proceeding.

---

### Step 1 — Working Title

Confirm a short working title for the problem frame. This becomes the heading and the `{feature-name}` slug.

- If the user's description contains a clear topic, propose a title and confirm.
- If ambiguous, ask: *"What short title should I use for this problem frame?"*

The title should describe the problem space, not a solution (e.g., "Onboarding Drop-off" not "Add Onboarding Wizard").

---

### Step 2 — Situation Context

Draft 2–4 sentences covering:
- **What is happening right now** — the current state
- **Who is affected** — the people experiencing the problem (users, team, customers, stakeholders)
- **What is the context** — relevant background (market, technical environment, org situation)
- **What triggered this** — why this is being examined now (metric drop, customer complaint, strategic shift, observed pattern)

If the user's initial description is thin on any dimension, ask targeted questions:
> *"What triggered this — was there a specific event, metric change, or feedback that made this visible?"*

Propose a draft. Ask for confirmation.

---

### Step 3 — Problem Statement

Craft a single sentence that captures the core problem. This is the hardest and most important step — a blurry problem statement poisons everything downstream.

**The sentence must:**
- Name who is affected
- Describe what they struggle with
- State the consequence

**Format:** *"[Who] struggles with [what] because [why], which results in [consequence]."*

Stress-test the draft:
1. **Is this the root problem or a symptom?** — If it sounds like a symptom (e.g., "users don't click the button"), dig deeper: why don't they click it?
2. **Who says it's a problem?** — Is there data, user feedback, or is this a hunch?
3. **What happens if we do nothing?** — If the answer is "not much", the problem may not be worth solving.

Propose the statement. Ask: *"Does this capture the core problem? Is any part of it a symptom rather than the real issue?"*

---

### Step 4 — Root Cause Analysis (Adaptive 5 Whys)

Starting from the problem statement, drill into root causes by asking "why" iteratively.

**How this works:**
1. Take the problem statement and ask: "Why does this happen?"
2. Take the answer and ask "Why?" again
3. Continue until you reach a cause that is either:
   - **Actionable** — something you could actually change
   - **Foundational** — a structural constraint that explains the pattern
   - **Circular** — you're looping back to a previous answer (stop here)

**Do not force 5 levels.** Stop when the root cause is genuine — forcing artificial depth produces nonsense. Most problems reach root cause in 3–4 levels.

**For each level, capture:**
- The "Why?" question
- The answer
- Whether this level feels like root cause or still a symptom

At the end, highlight the deepest causal factor and confirm with the user:
> *"It looks like the root cause is [X]. Does that feel right, or should we dig further?"*

Propose the chain. Ask for confirmation.

---

### Step 5 — Constraints & Boundaries

Identify what can't change and what's out of scope for this problem. Two categories:

**Hard Constraints** — things that are fixed and non-negotiable:
- Budget, timeline, team size
- Tech stack, platform, regulatory requirements
- Org structure, approval processes
- Existing commitments or dependencies

**Problem Boundaries** — what this problem frame is NOT about:
- Adjacent problems you're deliberately excluding
- Related symptoms you're choosing not to address
- Upstream causes you can't influence

If the user hasn't mentioned constraints, ask:
> *"What can't change here? Think about budget, timeline, tech stack, team, and anything that's non-negotiable."*

And for boundaries:
> *"What adjacent problems are you deliberately NOT trying to solve with this?"*

Propose the lists. Confirm.

---

### Step 6 — Success Definition

Define what "problem solved" looks like. This is not about features or solutions — it's about the observable change in the world.

**Structure:**
- **Target state** — 1–2 sentences describing what the situation looks like when the problem is solved
- **Measurable signals** — 3–5 specific indicators you'd check (metrics, behaviors, outcomes)
- **What "done" is NOT** — 1–2 things that might look like success but aren't (prevents false positives)

If the user struggles to articulate measurable signals, ask:
> *"If the problem were solved, what would you see change? What metric would move, what complaint would stop, what behavior would shift?"*

Propose a draft. Confirm.

---

### Step 7 — Alternative Framings

This is the stress-test. The skill proposes 2–3 different ways to frame the same problem. The goal is to check whether the chosen framing is actually the best angle of attack — or whether a reframe unlocks a better approach.

**How to generate alternative framings:**
- **Shift the "who"** — What if the problem is framed from a different stakeholder's perspective?
- **Shift the "what"** — What if the symptom you identified is actually the root cause of a different problem?
- **Shift the scope** — What if the problem is narrower (just one segment) or broader (systemic)?
- **Invert it** — What if the problem is actually an opportunity? ("Users don't engage" → "There's an untapped engagement surface")

For each alternative framing:
- State the reframed problem in one sentence
- Note what it would change about the approach
- Rate its strength: strong / moderate / weak

After proposing 2–3 framings, ask:
> *"Do any of these reframings feel more accurate than the original? Want to add your own?"*

The user can:
- Stick with the original
- Switch to an alternative
- Propose their own
- Blend elements from multiple framings

---

### Step 8 — Chosen Frame

Record which framing was selected and why. This becomes the anchor for everything downstream.

**Structure:**
- **Chosen framing** — the final problem statement (original or revised)
- **Why this frame** — 2–3 sentences explaining why this angle was chosen over the alternatives
- **What this frame prioritizes** — what aspects of the problem this framing emphasizes
- **What this frame deprioritizes** — what aspects are deliberately backgrounded (not ignored, but secondary)

Log the choice to `DECISION.md`.

---

### Step 9 — Assemble and Write

Once all sections are confirmed:
1. Read `references/template.md` for the exact output format
2. Assemble the final `PROBLEM-FRAME.md` content
3. Show the complete document to the user for a final review
4. Ask: *"Ready to write this file?"*
5. Write the file to `docs/features/{feature-name}/PROBLEM-FRAME.md`
6. Run validation: `bash scripts/validate-problem-frame.sh <path-to-file>`
7. Report the result

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Problem framing choices** — why the problem was stated a certain way
- **Root cause selection** — which "why" level was identified as root cause and why drilling stopped
- **Constraint trade-offs** — choices about what's fixed vs. flexible
- **Framing selection** — the chosen frame and why alternatives were rejected
- **Scope decisions** — what was deliberately excluded from the problem boundary

### What NOT to log

- Obvious, mechanical actions (e.g., "wrote the file", "used the template")
- Formatting or template-structure decisions already defined by the skill

### Entry format

Each decision follows this structure:

```markdown
## Decision {N}: {Short title}
**Status:** ✅ Accepted
**Date:** {YYYY-MM-DD}
**Skill:** create-problem-frame

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

> For simple decisions (e.g., confirming a working title), keep the entry lightweight — skip Options Considered and Consequences if they add no value. Use the full format for decisions that shape the problem's direction.

### When to write

Append decisions to `DECISION.md` as they happen during the interaction — do not batch them at the end.

---

## Rules

1. **Interactive first** — never generate the full problem frame from a single message without walking through each section.
2. **Propose, don't impose** — always show a draft of each section and ask for feedback before locking it in.
3. **No placeholders in the final file** — every field must contain real content.
4. **Strict structure** — only the sections defined in the template. No extra sections.
5. **Problems, not solutions** — if the user starts describing solutions, redirect: *"That sounds like a solution. What's the problem it solves?"*
6. **Adaptive depth** — the 5 Whys stops when root cause is reached. Don't force artificial depth.
7. **Language** — write the PROBLEM-FRAME.md in English, regardless of the language the user uses to interact.
8. **One section at a time** — do not dump all questions at once. Work through sections sequentially.

---

## Examples

### Example 1: Clear problem with obvious pain
User says: "Frame the problem around our checkout abandonment rate"
Actions:
1. Ask the user to describe the situation — what's happening, who's affected, what triggered the investigation
2. Confirm working title: "Checkout Abandonment"
3. Draft Situation Context → confirm → Draft Problem Statement → confirm → Run 5 Whys → confirm → ... (section by section)
4. Write to `docs/features/checkout-abandonment/PROBLEM-FRAME.md`
Result: A complete PROBLEM-FRAME.md built interactively, with root cause identified and alternative framings explored

### Example 2: Vague situation
User says: "I feel like our onboarding is broken"
Actions:
1. Ask: "Describe what's happening — what makes you think onboarding is broken? Any data or feedback?"
2. User provides a thin answer — skill probes deeper on who's affected and what the consequences are
3. Through the 5 Whys, discover the real issue is documentation gaps, not the onboarding flow itself
4. Propose alternative framings that shift from "onboarding UX" to "documentation discoverability"
Result: A problem frame that redirects effort from UI redesign to documentation — saving weeks of wasted work

### Example 3: User keeps jumping to solutions
User says: "We need to frame the problem — basically we need to add a caching layer"
Actions:
1. Redirect: "A caching layer sounds like a solution. What's the problem it solves? What's slow or broken today?"
2. Walk back from the solution to uncover the actual pain: API response times causing user drop-off
3. Through 5 Whys, discover the root cause is unoptimized database queries, not missing cache
4. Frame the problem around response time degradation, not caching
Result: A problem frame that opens up the solution space instead of pre-committing to one approach

---

## Troubleshooting

### Problem: User can't articulate the problem clearly
**Cause:** The problem is felt but not yet understood — this is exactly when problem framing is most valuable.
**Solution:** Start with concrete observations: *"What specific thing happened that made you think there's a problem? A user complaint? A metric change? Something you observed?"* Work from the concrete to the abstract.

### Problem: The 5 Whys goes in circles
**Cause:** Two causes are mutually reinforcing (A causes B, B causes A).
**Solution:** Acknowledge the loop, identify which node is more actionable, and designate it as the root cause. Log the circular dependency in the analysis.

### Problem: User insists on discussing solutions
**Cause:** Natural tendency to jump to fixes.
**Solution:** Acknowledge the solution, note it for later, and redirect: *"That's a good candidate solution — I'll note it. For now, let's make sure we've nailed the problem so we don't build the wrong thing."*

### Problem: PROBLEM-FRAME.md already exists
**Cause:** A previous session created one.
**Solution:** Inform the user and ask for confirmation before overwriting.
