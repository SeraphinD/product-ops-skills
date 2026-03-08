# Product Ops Skills

A collection of [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills that form a structured product development pipeline — from idea to actionable task list.

## The Pipeline

```
BRIEF → [BENCHMARK] → SPEC → [DESIGN] → PLAN → TASKS
```

Each skill transforms one artifact into the next, with interactive Q&A to ensure quality at every step. Optional stages (in brackets) can be skipped.

## Skills

| Skill | Input | Output | Description |
|-------|-------|--------|-------------|
| **create-brief** | Conversation | `BRIEF.md` | Interactively creates a project brief through structured Q&A covering problem statement, solution, objectives, scope, and success criteria |
| **brief-to-benchmark** | `BRIEF.md` | `BENCHMARK.md` | *(Optional)* Researches comparable solutions, technical standards, key metrics, and gap analysis to ground the spec in real-world data |
| **brief-to-specs** | `BRIEF.md` | `SPEC.md` | Generates user stories with MoSCoW/WSJF prioritization and acceptance criteria in Given/When/Then format |
| **spec-to-design** | `SPEC.md` | `DESIGN.md` | *(Optional, frontend only)* Produces a UI design document with design system, components, page layouts (ASCII wireframes), user flows, and WCAG 2.1 AA accessibility requirements |
| **spec-to-plan** | `SPEC.md` | `PLAN.md` | Creates a phased implementation plan with project structure, concrete steps per file, critical files list, and verification checklist |
| **plan-to-tasks** | `PLAN.md` | `TASKS.md` | Generates a flat, atomic task checklist where every action is traceable to a plan phase, has a status, and is assigned to a skill or agent |

## Installation

Add this repository as a skill source in your Claude Code configuration:

```bash
claude skill add /path/to/product-ops-skills/create-brief
claude skill add /path/to/product-ops-skills/brief-to-benchmark
claude skill add /path/to/product-ops-skills/brief-to-specs
claude skill add /path/to/product-ops-skills/spec-to-design
claude skill add /path/to/product-ops-skills/spec-to-plan
claude skill add /path/to/product-ops-skills/plan-to-tasks
```

## Usage

Start anywhere in the pipeline by asking Claude:

- **"Create a brief for user authentication"** — starts the pipeline from scratch
- **"Benchmark the brief"** — researches competitors and standards before writing specs
- **"Generate specs from the brief"** — converts a brief into detailed specifications
- **"Design the feature from the spec"** — creates a frontend design document
- **"Generate a plan from the spec"** — produces an implementation plan
- **"Turn the plan into tasks"** — creates an actionable task checklist

All artifacts are written to `docs/features/{feature-name}/` with decisions logged in `DECISION.md`.

## Key Features

- **Interactive workflow** — each skill works section by section, proposing drafts and asking for confirmation before moving on
- **Decision logging** — every non-obvious decision is tracked in `DECISION.md` for traceability
- **MoSCoW prioritization** — user stories are prioritized with WSJF scorecards (Must/Should/Could/Won't)
- **Pipeline continuity** — each skill reads upstream artifacts and respects prior decisions
- **Existing codebase awareness** — the design skill detects existing design systems (Tailwind, MUI, etc.) and extends them rather than starting from scratch

## License

[MIT](LICENSE)
