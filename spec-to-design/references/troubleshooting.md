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

## Problem: Both Figma and Paper MCP are detected
**Cause:** The user has both design tool MCPs configured in their environment.
**Solution:** The skill asks the user to pick one: *"I detected both Figma MCP and Paper MCP. Which design tool would you like to connect?"* Only one design tool can be `active` at a time. Log the choice to `DECISION.md`.

## Problem: Design tool MCP fails mid-run (Figma or Paper)
**Cause:** The MCP server disconnected, the design file was closed, or a tool call returned an error.
**Solution:** Log the failure to `DECISION.md`, complete the `DESIGN.md` as normal (markdown is always the primary output), and inform the user: *"{Tool} failed at step {X}. DESIGN.md is complete — you can scaffold manually."* Never block the DESIGN.md output on a design tool failure.

## Problem: Paper scaffold creates artboards but styles don't apply
**Cause:** `write_html` succeeded but `update_styles` failed — often due to node ID mismatch or unsupported CSS property.
**Solution:** Call `get_screenshot` to verify the current state. If styles are missing, re-read the node IDs with `get_tree_summary` and retry `update_styles` on the correct nodes. If the issue persists, complete the scaffold without styles and note it: *"Artboards created but styles need manual application."*

## Problem: Figma token extraction returns empty results
**Cause:** `get_variable_defs` or `get_design_context` returned no data — the file may have no local styles/variables, or the node ID targets an empty section.
**Solution:** Try `get_metadata` first to find the right page/node with design system content. If the file genuinely has no tokens, fall back to codebase-only path and inform the user: *"No design tokens found in your Figma file. I'll scan the codebase instead."*
