# Product Ops Skills

A collection of [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills that form a structured product development pipeline — from idea to actionable task list.

## The Pipeline

```
BRIEF → [BENCHMARK] → SPEC → [DESIGN] → PLAN → TASKS
```

Both `spec-to-design` (web) and `spec-to-mobile-design` (native mobile) are optional and output `DESIGN.md`. Run one or the other for a given feature, not both.

Each skill transforms one artifact into the next, with interactive Q&A to ensure quality at every step. Optional stages (in brackets) can be skipped.

## Skills

| Skill | Input | Output | Description |
|-------|-------|--------|-------------|
| **create-brief** | Conversation | `BRIEF.md` | Interactively creates a project brief through structured Q&A covering problem statement, solution, objectives, scope, and success criteria |
| **brief-to-benchmark** | `BRIEF.md` | `BENCHMARK.md` | *(Optional)* Researches comparable solutions, technical standards, key metrics, and gap analysis to ground the spec in real-world data |
| **brief-to-specs** | `BRIEF.md` | `SPEC.md` | Generates user stories with MoSCoW/WSJF prioritization and acceptance criteria in Given/When/Then format |
| **spec-to-design** | `SPEC.md` | `DESIGN.md` | *(Optional, web only)* Produces a UI design document with design system, components, page layouts (ASCII wireframes), user flows, and WCAG 2.1 AA accessibility requirements |
| **spec-to-mobile-design** | `SPEC.md` | `DESIGN.md` | *(Optional, native mobile only)* Produces a mobile design document with platform-specific design tokens (pt/dp/sp), native components (iOS HIG + Material Design 3), screen layouts, navigation architecture, gestures, haptics, and VoiceOver/TalkBack accessibility |
| **spec-to-plan** | `SPEC.md` | `PLAN.md` | Creates a phased implementation plan with project structure, concrete steps per file, critical files list, and verification checklist |
| **plan-to-tasks** | `PLAN.md` | `TASKS.md` | Generates a flat, atomic task checklist where every action is traceable to a plan phase, has a status, and is optionally assigned to an installed skill |

## Installation

Add this repository as a skill source in your Claude Code configuration:

```bash
for skill in create-brief brief-to-benchmark brief-to-specs spec-to-design spec-to-mobile-design spec-to-plan plan-to-tasks; do
  ln -s "/path/to/product-ops-skills/$skill" "$HOME/.claude/skills/$skill"
done
```

## Usage

Start anywhere in the pipeline by asking Claude:

- **"Create a brief for user authentication"** — starts the pipeline from scratch
- **"Benchmark the brief"** — researches competitors and standards before writing specs
- **"Generate specs from the brief"** — converts a brief into detailed specifications
- **"Design the feature from the spec"** — creates a web frontend design document
- **"Mobile design from the spec"** — creates a native mobile design document (iOS/Android)
- **"Generate a plan from the spec"** — produces an implementation plan
- **"Turn the plan into tasks"** — creates an actionable task checklist

All artifacts are written to `docs/features/{feature-name}/` with decisions logged in `DECISION.md`.

## Key Features

- **Interactive workflow** — each skill works section by section, proposing drafts and asking for confirmation before moving on
- **Decision logging** — every non-obvious decision is tracked in `DECISION.md` for traceability
- **MoSCoW prioritization** — user stories are prioritized with WSJF scorecards (Must/Should/Could/Won't)
- **Pipeline continuity** — each skill reads upstream artifacts and respects prior decisions
- **Existing codebase awareness** — design skills detect existing design systems (Tailwind, MUI, React Native themes, Flutter ThemeData, etc.) and extend them rather than starting from scratch
- **Native mobile support** — `spec-to-mobile-design` covers iOS HIG, Material Design 3, platform-native units (pt/dp/sp), VoiceOver, TalkBack, gestures, haptics, and safe areas

## License

[MIT](LICENSE)
