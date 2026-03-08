# Troubleshooting — spec-to-mobile-design

## Problem: SPEC describes a web feature, not a mobile app
**Cause:** The skill was triggered for a feature targeting web browsers.
**Solution:** The skill will detect this in Step 5 and inform the user: "This SPEC describes a web feature. DESIGN.md is for native mobile apps. Did you mean to use spec-to-design instead?" If ambiguous, it asks for clarification.

## Problem: SPEC targets both web and mobile
**Cause:** The feature has both web and native mobile components.
**Solution:** Both skills write to `DESIGN.md`. Run one skill at a time and let the user decide which design to keep, or inform them: "This feature has both web and mobile components. Running both spec-to-design and spec-to-mobile-design will overwrite the same `DESIGN.md`. Decide which platform to design first, then the other."

## Problem: Existing design system uses a different convention than proposed
**Cause:** Step 6 detected a design system but the proposed design tokens conflict with existing patterns.
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
