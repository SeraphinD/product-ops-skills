# PLAN.md Output Template

The final `PLAN.md` must follow **exactly** this structure:

```markdown
# Implementation Plan: {Feature Name}

> Generated from: {relative path to SPEC.md}

## Overview
{1–2 sentences describing what needs to be implemented, referencing the spec file by relative path}

## Requirements Summary
- **{Key Requirement 1}:** {value}
- **Stack:** {tech stack}
- **Success Output:** {expected output or observable behavior}
- **Error Handling:** {how failure cases are handled}

## Project Structure
```
{root}/
├── docs/
│   └── features/
│       └── {feature-name}/
│           ├── SPEC.md              # Specifications
│           └── PLAN.md              # This file
├── {source files and folders}
├── tests/
│   └── {test files}
└── README.md
```

## Implementation Steps

### Phase 1 — MUST: {Phase Name}

#### Sub-Phase 1.0 — Experiment Infrastructure
<!-- Include only when SPEC has Experimentation Strategy sections and tooling is available -->
1. {Feature flag system setup} — {configure flags for each EXP-ID}
2. {Analytics event instrumentation} — {track primary and guardrail metrics}
3. {Variant routing logic} — {assign users to control/variant}

1. {File or component to create} — {what it does}
2. {File or component to create} — {what it does}

### Phase 2 — SHOULD: {Phase Name}
1. {File or component to create} — {what it does}

### Phase 3 — COULD (optional): {Phase Name}
> This phase is optional — it can be dropped without affecting core functionality.

1. {File or component to create} — {what it does}

### Phase N — Testing
1. {Test file} with tests for:
   - {Scenario name}: `{input/command}` → `{expected output}` (exit {code})

### Phase N+1 — Documentation
1. {File to create} with:
   - {Section or content to include}

## Critical Files
- `{path/to/file}` — {role or responsibility}
- `{path/to/file}` — {role or responsibility}

## Verification Checklist
- [ ] {Acceptance criterion taken verbatim or paraphrased from SPEC}
- [ ] All tests pass: `{test command}`
- [ ] Feature flag toggles correctly between control and variant
- [ ] Primary metric events fire in both control and variant paths
- [ ] Guardrail metric events fire in both paths

## Implementation Details

### {Technical Topic — e.g., CLI Argument Parsing}
{Concrete details: library choice, configuration, flags, patterns to follow}

### Error Messages
{Exact wording of error messages when specified in the spec}

### Constraints & Guidelines
- {Implementation guideline or constraint from the spec}
- {Library or tool choice rationale}

### Experimentation Infrastructure
<!-- Include only when experiment infrastructure is planned -->
{Tooling choice, traffic allocation mechanism, analytics pipeline, kill switch procedure}
```
