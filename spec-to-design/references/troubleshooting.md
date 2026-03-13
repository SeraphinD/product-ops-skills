# Troubleshooting — spec-to-design

## Problem: SPEC describes a backend-only feature
**Cause:** The skill was triggered for a feature with no user interface.
**Solution:** The skill will detect this in Step 6 and inform the user: "This SPEC describes a backend/CLI feature. DESIGN.md is for features with a UI. Would you like to skip to PLAN?" If ambiguous, it asks for clarification.

## Problem: Existing design system uses a different convention than proposed
**Cause:** Step 7 detected a design system but the proposed design tokens conflict with existing patterns.
**Solution:** Always reuse existing tokens. Mark inherited values as `Existing` and only add new tokens the feature requires. Never override or propose alternatives to established design tokens.

## Problem: SPEC has no MoSCoW labels
**Cause:** The SPEC was generated before the prioritization convention was introduced.
**Solution:** Treat all User Stories as MUST and proceed with full design treatment for every story. Note this in the DESIGN.md overview.

## Problem: ASCII wireframes are too complex to be readable
**Cause:** The page layout has many nested components.
**Solution:** Break complex layouts into multiple diagrams — one for the overall page structure, and separate detail diagrams for complex component groups. Label each diagram clearly.

## Problem: Multiple design systems detected in the codebase
**Cause:** The project uses both a CSS framework (e.g., Tailwind) and a component library (e.g., MUI), or has legacy and modern systems coexisting.
**Solution:** Ask the user which system to align with: *"I found both Tailwind tokens and MUI theme values. Which should the design extend?"* Use the chosen system's conventions and note the decision in DECISION.md.

## Problem: SPEC user stories don't imply enough UI to fill all design sections
**Cause:** The feature is UI-light (e.g., a settings toggle or a single form).
**Solution:** Scale the design to match the scope. A single-screen feature doesn't need 6 page layouts. Keep sections proportional — a minimal feature gets minimal design. Skip or reduce sections that don't apply, but always include Design System, Components, and Accessibility.

## Problem: Color palette doesn't meet WCAG contrast ratios
**Cause:** The proposed or existing colors fail the 4.5:1 / 3:1 contrast requirement.
**Solution:** Adjust the failing colors to meet WCAG AA. Show the user the before/after: *"The existing primary color (#6B7EFF) has a 3.2:1 contrast ratio on white — below the 4.5:1 minimum. I'll darken it to #4A5FE0 (5.1:1). OK?"*

## Problem: BENCHMARK.md visual references look too similar to proposed design
**Cause:** Benchmark competitor layouts influenced the design too heavily.
**Solution:** Review for originality. The design should be *informed by* benchmarks, not a copy. If layouts are too similar, rework the component arrangement and visual hierarchy while keeping the functional requirements from the SPEC.
