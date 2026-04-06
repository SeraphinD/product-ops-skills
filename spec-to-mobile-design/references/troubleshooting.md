# Troubleshooting — spec-to-mobile-design

## Problem: SPEC describes a web feature, not a mobile app
**Cause:** The skill was triggered for a feature targeting web browsers.
**Solution:** The skill will detect this in Step 6 and inform the user: "This SPEC describes a web feature. DESIGN.md is for native mobile apps. Did you mean to use spec-to-design instead?" If ambiguous, it asks for clarification.

## Problem: SPEC targets both web and mobile
**Cause:** The feature has both web and native mobile components.
**Solution:** Both skills write to `DESIGN.md`. Run one skill at a time and let the user decide which design to keep, or inform them: "This feature has both web and mobile components. Running both spec-to-design and spec-to-mobile-design will overwrite the same `DESIGN.md`. Decide which platform to design first, then the other."

## Problem: Existing design system uses a different convention than proposed
**Cause:** Step 7 detected a design system but the proposed design tokens conflict with existing patterns.
**Solution:** Always reuse existing tokens. Mark inherited values as `Existing` and only add new tokens the feature requires. Never override or propose alternatives to established design tokens.

## Problem: iOS and Android designs diverge significantly
**Cause:** The feature requires genuinely different UX on each platform (e.g., iOS uses swipe navigation, Android uses bottom navigation bar).
**Solution:** Document both variants in the component and screen layout sections. Use separate ASCII wireframes when layouts differ materially. Clearly label which platform each diagram represents.

## Problem: SPEC has no MoSCoW labels
**Solution:** Treat all User Stories as MUST and proceed with full design treatment. Note this in the DESIGN.md overview.

## Problem: ASCII wireframes are too complex to be readable
**Solution:** Break complex layouts into multiple diagrams — one for overall structure, separate detail diagrams for complex groups. If showing both platforms, use side-by-side diagrams or separate clearly labeled sections.

## Problem: Framework not detected in codebase
**Cause:** The project is greenfield or the framework hasn't been chosen yet.
**Solution:** Ask the user: *"I couldn't detect a mobile framework in the codebase. Which framework will you use? (React Native, Flutter, SwiftUI, Jetpack Compose, Expo, etc.)"* This determines component vocabulary, design tokens, and platform conventions. Log the decision.

## Problem: Safe area insets vary across device models
**Cause:** Different iPhone models have different notch/Dynamic Island sizes; Android devices have varying status bar heights.
**Solution:** Use the standard safe area values from the template (59pt Dynamic Island, 47pt notch, 20pt no notch for iOS; 24dp status bar for Android). Note in the design that actual values come from system APIs at runtime — the design specifies minimum padding, not exact pixel values.

## Problem: Haptic feedback seems unnecessary for the feature
**Cause:** The feature is primarily informational with few interactive elements.
**Solution:** Haptics are optional. If the feature has no meaningful tactile interactions (no destructive actions, no selection changes, no confirmations), omit the Haptics subsection. Keep the Gestures subsection if any gesture-based interactions exist (pull-to-refresh, swipe, etc.).

## Problem: Design needs to support both portrait and landscape
**Cause:** The SPEC or user requires landscape support (e.g., media playback, data tables).
**Solution:** Document both orientations in the Screen Layouts section with separate ASCII wireframes. Specify which components reflow and which stay fixed. Note landscape support in the Adaptive Layout section under Orientation.

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

## Problem: Paper MCP can't find platform-specific artboards
**Cause:** `get_tree_summary` returns artboards but none are labeled with iOS/Android platform identifiers.
**Solution:** Create platform-labeled artboards from scratch: `[Screen Name] — iOS` and `[Screen Name] — Android`. Don't assume existing artboards map to specific platforms unless clearly named.
