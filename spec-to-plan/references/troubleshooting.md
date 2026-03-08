# Troubleshooting — spec-to-plan

## Problem: SPEC has no clear tech stack
**Cause:** The specification doesn't mention a language, framework, or runtime.
**Solution:** Ask in the gap analysis phase: "The spec doesn't specify a tech stack. I'll assume {reasonable default based on context}. OK?" Propose a default based on any clues (file extensions mentioned, test frameworks, etc.).

## Problem: Feature is too small for multiple phases
**Cause:** The spec describes a trivial feature with 1-2 source files.
**Solution:** Collapse into a single implementation phase. Don't artificially split small features into phases. The Testing and Documentation phases still exist separately.

## Problem: DESIGN.md exists but conflicts with SPEC
**Cause:** The design document was written before a spec change, or they were authored independently.
**Solution:** The SPEC takes precedence for functional requirements. The DESIGN.md provides UI implementation guidance. Flag conflicts: "The DESIGN.md shows component X, but the SPEC doesn't mention this functionality. Should I include it in the plan?"

## Problem: Verification checklist items are vague
**Cause:** The spec's acceptance criteria use vague language that doesn't translate to concrete checks.
**Solution:** Transform vague criteria into specific checkable statements. Instead of "handles errors properly", write: `python -m app hello "" → 'Error: Name cannot be empty' (exit 1)`. If the spec doesn't provide enough detail, flag the gap.

## Problem: COULD phase scope is unclear
**Cause:** COULD stories are inherently lower-priority and may lack detailed acceptance criteria.
**Solution:** Keep the COULD phase lean — list the stories and their functional scope but mark the phase clearly: *"This phase is optional — can be dropped without affecting core functionality."* Don't spend effort on detailed implementation steps for COULD stories.

## Problem: Testing phase is too generic
**Cause:** The plan lists "write tests" without specifying what to test or which framework.
**Solution:** Derive test targets from the SPEC's acceptance criteria. Each AC should map to at least one test case. Specify the test framework based on the tech stack. Example: "Test US-1 AC-1: `pytest tests/test_auth.py::test_login_valid_credentials`."

## Problem: Project structure doesn't match existing codebase
**Cause:** The planned file structure conflicts with the project's established conventions.
**Solution:** Scan the existing codebase for patterns (directory naming, module organization, test locations). Align the plan's project structure with existing conventions. If the plan requires a different structure, flag it: *"The existing project uses `src/` layout but the plan proposes `app/`. Should I match the existing convention?"*

## Problem: Critical files list is too long
**Cause:** Every file feels critical when the feature is complex.
**Solution:** Critical files are only those whose absence *breaks* the feature — entry point, core logic module, and primary test file. Supporting files (utilities, configs, documentation) are important but not critical. Limit to 3-7 files.
