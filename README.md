# Product Ops Skills

A set of [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills that guide you through building a software feature — from raw idea to an actionable task list — with structured documents at every step.

Each skill takes one document as input and produces the next. You confirm each section before anything is written, so nothing gets generated behind your back.

### Why this matters for Product Ops

Most teams lose clarity somewhere between ideation and delivery. A feature starts as a Slack message, turns into a vague Jira ticket, and arrives in development with half the context missing — no one remembers *why* a decision was made, what was deliberately left out, or what "done" actually looks like. The result is rework, scope creep, and misaligned expectations across PM, design, and engineering.

This pipeline enforces the discipline that prevents those failures:

- **Every decision is traceable.** Each skill logs its non-obvious choices to `DECISION.md`. When a developer asks "why is this MUST and not SHOULD?" or "why did we choose tab navigation over a drawer?", the answer is in writing — not locked in someone's memory or a meeting recording.
- **Scope is decided once and respected everywhere.** WON'T stories defined in the SPEC are never designed, never planned, never tasked. Downstream skills read and enforce upstream decisions rather than reopening them.
- **Handoffs have a defined format.** BRIEF → SPEC → PLAN → TASKS is a structured contract between roles. A PM writes the brief; the spec gives engineering a shared language; the plan gives a technical lead what they need to estimate; the task list is ready for sprint planning. No translation layer needed.
- **Nothing is generated without your sign-off.** Each skill works section by section and waits for confirmation before writing. This keeps Claude as a collaborator, not an autonomous agent producing documents you then have to undo.
- **You can enter at any stage.** Already have a spec? Skip to `spec-to-plan`. Already have a plan? Skip to `plan-to-tasks`. The pipeline is a full path, not a mandatory process.

---

## How It Works

```
[PROBLEM FRAME] → BRIEF → [BENCHMARK] → SPEC → [DESIGN] → PLAN → TASKS
```

| Stage | What it produces | Why | Optional? |
|---|---|---|---|
| **create-problem-frame** | `PROBLEM-FRAME.md` — situation context, root cause analysis, constraints, alternative framings | Prevents building the right solution to the wrong problem | ✅ Yes |
| **create-brief** | `BRIEF.md` — problem, solution, objectives, scope, success criteria | Aligns everyone on what to build and why before any work starts | No — starting point |
| **brief-to-benchmark** | `BENCHMARK.md` — competitors, standards, metrics, gap analysis | Grounds decisions in real-world data instead of assumptions | ✅ Yes |
| **brief-to-specs** | `SPEC.md` — user stories, MoSCoW/WSJF scores, Given/When/Then ACs | Turns intent into testable requirements with clear priority | No |
| **spec-to-design** | `DESIGN.md` — design system, components, wireframes, flows *(web)* | Catches UX issues on paper before they become code | ✅ Yes |
| **spec-to-mobile-design** | `DESIGN.md` — same, but for native iOS/Android | Same, with platform-specific patterns for iOS and Android | ✅ Yes |
| **spec-to-plan** | `PLAN.md` — phased implementation steps, file tree, critical files, verification checklist | Gives engineering a buildable sequence, not just a wish list | No |
| **plan-to-tasks** | `TASKS.md` — flat, atomic task list with statuses and optional skill assignments | Makes the plan trackable — every task maps to a plan step | No |

> **Design note:** `spec-to-design` (web) and `spec-to-mobile-design` (native mobile) both write to `DESIGN.md`. Run one or the other for a given feature, not both.

All files are written to `docs/features/{feature-name}/`. Every non-obvious decision is logged to `DECISION.md` in the same folder and carried forward by subsequent skills.

---

## Installation

Clone the repo and symlink each skill into your user-level Claude Code skills directory:

```bash
REPO="/path/to/product-ops-skills"

for skill in create-problem-frame create-brief brief-to-benchmark brief-to-specs spec-to-design spec-to-mobile-design spec-to-plan plan-to-tasks; do
  ln -sf "$REPO/$skill" "$HOME/.claude/skills/$skill"
done
```

Symlinks mean any change you make to the repo is immediately live — no re-installation needed.

To verify the skills are installed:

```bash
ls -la ~/.claude/skills/
```

---

## Complete Workflow Example

Here is a full run-through for a fictional feature: **"Push Notifications for a React Native app"**.

---

### Step 0 — Frame the Problem (optional)

> **You:** Frame the problem around push notification engagement in our React Native app

Claude triggers `create-problem-frame` and walks you through structured Q&A to clarify the problem before anyone jumps to solutions. It captures the current situation, crafts a single-sentence problem statement, runs an adaptive root cause analysis (5 Whys), maps constraints, defines what success looks like, and stress-tests the framing by proposing 2–3 alternative angles.

**Output:** `docs/features/push-notifications/PROBLEM-FRAME.md`

```
Situation Context       ← what's happening now, who's affected, what triggered this
Problem Statement       ← single sentence: [who] struggles with [what] because [why]
  Stress Test           ← root or symptom? evidence basis? cost of inaction?
Root Cause Analysis     ← adaptive Why Chain (2–5 levels) + root cause
Constraints & Boundaries← hard constraints + excluded adjacent problems
Success Definition      ← target state, measurable signals, what success is NOT
Alternative Framings    ← 2–3 reframes with strength ratings
Chosen Frame            ← selected framing + rationale + prioritizes/deprioritizes
```

Skip this step if the problem is already well-understood and validated.

---

### Step 1 — Create the Brief

> **You:** Create a brief for push notifications in our React Native app

Claude triggers `create-brief` and walks you through a Q&A covering: what problem you're solving, what the solution is, objectives (3–7), in-scope and out-of-scope items, and success criteria. If a `PROBLEM-FRAME.md` exists, the brief is grounded in its validated problem statement and root cause.

**Output:** `docs/features/push-notifications/BRIEF.md`

```
Executive Summary
Problem Statement       ← why push notifications are needed
Solution                ← what the feature does
Key Objectives          ← measurable goals
Scope                   ← what's in / what's out
Success Criteria        ← how you'll know it worked
```

---

### Step 2 — Benchmark (optional)

> **You:** Benchmark the brief

Claude triggers `brief-to-benchmark` and researches: comparable apps (Firebase Cloud Messaging, OneSignal, Expo Notifications), delivery rate baselines, opt-in rate industry standards, and what gaps your brief has compared to best-in-class.

**Output:** `docs/features/push-notifications/BENCHMARK.md`

Skip this step if you already know the competitive landscape.

---

### Step 3 — Generate the Spec

> **You:** Generate specs from the brief

Claude triggers `brief-to-specs` and produces prioritized user stories. Each story gets a MoSCoW label (MUST/SHOULD/COULD/WON'T) and a WSJF score, plus concrete acceptance criteria in Given/When/Then format.

**Output:** `docs/features/push-notifications/SPEC.md`

```
## User Story 1 — MUST (WSJF: 13)
As a user, I want to receive push notifications...

### Acceptance Criteria
Given I have enabled notifications
When a new message arrives
Then I receive a push notification within 3 seconds
```

---

### Step 4 — Design (optional)

**Web feature:**
> **You:** Design the feature from the spec

**Native mobile feature (this example):**
> **You:** Mobile design from the spec

Claude triggers `spec-to-mobile-design`, detects the React Native project and any existing theme, then proposes: design tokens (colors in hex, typography in sp, spacing in dp), native components (e.g., `NotificationBanner`, `PermissionPrompt`), screen layouts as ASCII wireframes, and VoiceOver + TalkBack accessibility specs.

**Output:** `docs/features/push-notifications/DESIGN.md`

```
## Design System
Colors: #1A73E8 (primary), #E8F0FE (surface)...
Typography: 16sp body, 14sp caption (Roboto)
Spacing: 8dp base unit

## Components
NotificationBanner — toast-style overlay, swipe-to-dismiss
PermissionPrompt — modal with allow/deny, TalkBack-labelled

## Screen Layouts
[ASCII wireframe of notification list screen]
```

---

### Step 5 — Generate the Plan

> **You:** Generate a plan from the spec

Claude triggers `spec-to-plan`, reads the SPEC (and DESIGN.md if present), and produces a phased implementation plan. MUST stories become Phase 1, SHOULD become Phase 2, COULD become Phase 3 (optional), then Testing and Documentation.

**Output:** `docs/features/push-notifications/PLAN.md`

```
## Phase 1 — MUST
  1.1  Design System Setup — create theme tokens, base component scaffolding
  1.2  Create NotificationService.ts — FCM/Expo integration
  1.3  Create PermissionPrompt component
  ...

## Phase 2 — SHOULD
  2.1  Create notification preferences screen
  ...

## Verification Checklist
  [ ] npx jest → all tests pass
  [ ] Push sent from dashboard → received within 3s on device
```

---

### Step 6 — Generate the Task List

> **You:** Turn the plan into tasks

Claude triggers `plan-to-tasks`, maps every plan step to an atomic task, and optionally assigns each task to an installed skill. Every task references the exact PLAN phase and step it came from.

**Output:** `docs/features/push-notifications/TASKS.md`

```
## Phase 1 — MUST

⬜ Create NotificationService.ts — FCM integration layer
   Ref: PLAN.md Phase 1, Step 1.2
   Notes: Depends on: Design System Setup

⬜ Create PermissionPrompt component
   Ref: PLAN.md Phase 1, Step 1.3
   Skill: spec-to-mobile-design
```

---

### What You End Up With

After the full pipeline, your feature folder looks like this:

```
docs/features/push-notifications/
├── PROBLEM-FRAME.md← validated problem definition (optional)
├── BRIEF.md        ← problem, solution, objectives, scope
├── BENCHMARK.md    ← competitive research (optional)
├── SPEC.md         ← user stories + acceptance criteria
├── DESIGN.md       ← UI/UX design (optional)
├── PLAN.md         ← phased implementation steps
├── TASKS.md        ← atomic task list
└── DECISION.md     ← full log of every decision made
```

You can enter the pipeline at any stage — if you already have a SPEC, start from Step 3. If you have a PLAN, start from Step 6. If the problem is already clear, skip Step 0 and start with the Brief.

---

## Key Design Principles

- **Interactive, not automated** — every skill proposes drafts section by section and waits for your confirmation. Nothing is written without approval.
- **Decision continuity** — every non-obvious decision is logged to `DECISION.md` and treated as a hard constraint by all downstream skills. Change your mind? Update the decision log.
- **MoSCoW-aware depth** — MUST stories get full treatment at every stage. SHOULD gets moderate depth. COULD gets stubs. WON'T is never planned, designed, or tasked.
- **Codebase-aware design** — design skills scan your project for an existing design system (Tailwind, MUI, React Native themes, Flutter `ThemeData`, `Assets.xcassets`) and extend it rather than replacing it.
- **No filler** — every generated section is grounded in the spec or prior artifacts. Generic best-practice advice not derived from your documents is never added.

---

## License

[MIT](LICENSE)
