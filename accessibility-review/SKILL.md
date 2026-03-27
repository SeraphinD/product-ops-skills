---
name: accessibility-review
description: Reviews any pipeline artifact (BRIEF, SPEC, DESIGN, or PLAN) for accessibility compliance — covering WCAG 2.1 AA for web, VoiceOver/TalkBack for native mobile, and RGAA for French compliance. Platform-aware — adapts review to web, iOS, Android, or cross-platform (React Native, Flutter). Produces an ACCESSIBILITY-REVIEW.md with findings, compliance ACs, and citations to official standards. Trigger on phrases like "accessibility review", "a11y check", "WCAG review", "check accessibility", "VoiceOver review", "TalkBack review", "RGAA review", "screen reader audit", or when the user wants to assess a feature's accessibility. Do NOT use for GDPR (use gdpr-review) or AI Act compliance (use ai-act-review). This skill reviews existing artifacts only — it does not generate briefs, specs, or plans.
allowed-tools: "Read Write Glob Grep WebSearch WebFetch"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: compliance
  tags: [accessibility, a11y, wcag, rgaa, voiceover, talkback, compliance, review, cross-cutting]
---

# Accessibility Review Skill

This skill reviews any pipeline artifact for accessibility compliance. It is **platform-aware** — it detects whether the feature targets web, iOS, Android, or cross-platform and adapts its review accordingly.

This is a **cross-cutting review skill** — it runs alongside the pipeline, not as a sequential stage:

```
[PROBLEM FRAME] → BRIEF → [BENCHMARK] → [OPPORTUNITY] → SPEC → [DESIGN] → PLAN → TASKS → [EXECUTION] → [RETRO]
                     ↑                                      ↑        ↑         ↑
                     └──── Accessibility review can run at any of these stages ─┘
```

**Artifact produced:** `docs/features/{feature-name}/ACCESSIBILITY-REVIEW.md`

## Performance Notes

- Take your time with every component and criterion. Missing a single WCAG success criterion or platform guideline can leave an entire user group unable to use the feature.
- Quality and completeness are more important than speed. Audit every interactive element against the relevant checklist for the detected platform.
- Do not skip validation steps or merge findings into vague summaries. Each finding must cite the specific criterion (WCAG, RGAA, HIG, Material) and, when consulted, the official source.
- When uncertain whether a component meets a criterion, err on the side of flagging it — a false positive that gets reviewed is better than a barrier that ships to users who rely on assistive technology.

---

## Output Template

**Before writing any output, read `references/template.md` for the exact ACCESSIBILITY-REVIEW.md structure.**

**After writing, run `bash scripts/validate-accessibility-review.sh {path-to-review}` to verify structural completeness.**

---

## Platform Detection

The skill detects the target platform from the artifact or BRIEF context and adapts its review:

| Signal | Platform |
|---|---|
| React, Vue, Angular, Svelte, Next.js, Nuxt, Tailwind, HTML, CSS, browser | **Web** |
| React Native, Expo, NativeWind | **Cross-platform (RN)** |
| Flutter, Dart, Widget | **Cross-platform (Flutter)** |
| SwiftUI, UIKit, iOS, VoiceOver, `.xcodeproj` | **iOS** |
| Jetpack Compose, Kotlin, Android, TalkBack, Material 3 | **Android** |

If ambiguous, ask the user:
> "I can't determine the target platform from the artifact. Is this a web feature, native mobile (iOS/Android), or cross-platform (React Native/Flutter)?"

---

## Review Depth by Artifact Type

| Artifact | Review Mode | Depth | What it produces |
|----------|-------------|-------|------------------|
| BRIEF | Triage | Light | Short assessment: is there a UI? Which platform? Any disability-related context? Initial flags |
| SPEC | Deep | Full | Complete review: WCAG/platform criteria mapped to acceptance criteria, compliance ACs |
| DESIGN | Deep | Full | Component-level audit: contrast, focus, ARIA/VoiceOver/TalkBack, touch targets, motion |
| PLAN | Verify | Moderate | Checks a11y testing tasks, audit steps, tool recommendations. Gap report |

---

## Interaction Protocol

Work section by section. For each section:
1. Share what you've identified from the artifact
2. Propose your findings as a draft
3. Ask for confirmation or adjustments before moving on
4. Never skip a section — if you can't assess confidently, ask a targeted question

**Never generate the full review in one shot without confirming each major block** with the user first.

---

## Step-by-Step Process

### Step 1 — Locate the Artifact

Find the target artifact. Look in this order:
1. The path the user provides directly
2. `docs/features/*/` matching any feature name in context — scan for BRIEF.md, SPEC.md, DESIGN.md, PLAN.md
3. Any pipeline artifact in the current working directory

If multiple artifacts exist and the user didn't specify which one to review, ask:
> "I found {list of artifacts} for `{feature-name}`. Which one should I review? (DESIGN gives the deepest UI coverage; SPEC gives AC-level analysis.)"

If no artifacts are found, ask the user to provide the path.

### Step 2 — Detect Artifact Type and Platform

Determine the artifact type (sets review depth) and platform (sets which standards to apply):

**Artifact type detection:**
- `BRIEF.md` or `# Project Brief:` → **Triage mode**
- `SPEC.md` or `Specifications` in title → **Deep mode**
- `DESIGN.md` or `## Design System` → **Deep mode (design)**
- `PLAN.md` or `# Implementation Plan:` → **Verify mode**

**Platform detection:**
- Scan the artifact and any loaded BRIEF for platform signals (see Platform Detection table above)
- If a `DESIGN.md` was generated by `spec-to-mobile-design`, the platform is mobile
- If a `DESIGN.md` was generated by `spec-to-design`, the platform is web

Announce:
> "Reviewing `{artifact}` in **{mode}** mode for **{platform}** accessibility."

### Step 3 — Load Prior Review

Check if an `ACCESSIBILITY-REVIEW.md` already exists in `docs/features/{feature-name}/`.

If it exists:
1. Read it in full
2. Inform the user: *"A prior accessibility review exists (dated {date}). I'll highlight what's changed."*
3. During the review, mark findings as "Previously identified" or "New finding"

### Step 4 — Load Domain Knowledge

Based on the detected platform, read the appropriate reference files:
- **Web:** `references/wcag-checklist.md`
- **Mobile / Cross-platform:** `references/mobile-accessibility-checklist.md`
- **Both (cross-platform):** read both files

### Step 5 — Load Prior Decisions

Check whether a `DECISION.md` exists in `docs/features/{feature-name}/`.

If it exists, read it in full:
- Treat every ✅ Accepted decision as a hard constraint
- If a prior decision conflicts with an accessibility requirement, flag it: *"Decision {N} says X, but WCAG {criterion} requires Y."*

### Step 6 — Consult Official Sources

For the relevant accessibility standards, use `WebSearch` and `WebFetch` to consult official sources:
- **Web:** W3C WCAG 2.1/2.2 (`w3.org/WAI/WCAG21`), WAI-ARIA (`w3.org/WAI/ARIA`)
- **iOS:** Apple HIG Accessibility (`developer.apple.com/design/human-interface-guidelines/accessibility`)
- **Android:** Android Accessibility (`developer.android.com/guide/topics/ui/accessibility`)
- **French standard:** RGAA (`accessibilite.numerique.gouv.fr`)
- **Non-web ICT:** WCAG2ICT (`w3.org/TR/wcag2ict`)

Cite the source URL for each finding.

### Step 7 — Run the Review (Triage Mode — BRIEF)

If reviewing a BRIEF:

1. **UI Detection** — does the feature have a user interface? If no UI, note it and end the review: *"This feature has no UI — accessibility review is not applicable."*
2. **Platform Detection** — web, mobile, or cross-platform?
3. **User Context** — scan for mentions of target users, disability considerations, assistive technology requirements
4. **Initial Flags** — based on the feature scope, flag likely accessibility concerns:
   - Forms → label association, error handling, keyboard navigation
   - Data visualization → color-only information, text alternatives
   - Navigation → focus management, screen reader announcements
   - Media → captions, audio descriptions
   - Animations → reduced motion preferences
5. **Recommendations for SPEC** — list what accessibility-related ACs should be included

Present findings and confirm.

### Step 8 — Run the Review (Deep Mode — SPEC)

If reviewing a SPEC:

**Web platform:**
1. **WCAG 2.1 AA Audit** — for each User Story's functional scope and acceptance criteria, check against relevant WCAG success criteria (see `references/wcag-checklist.md`)
2. **Keyboard Navigation** — can every interactive element be reached and operated via keyboard?
3. **Screen Reader Support** — are ARIA roles, labels, and live regions specified for dynamic content?
4. **Focus Management** — is focus order logical? Is focus trapped appropriately in modals?
5. **Color and Contrast** — are contrast requirements specified? Is information conveyed by means other than color alone?
6. **Error Handling** — are error messages associated with their inputs? Are they announced to screen readers?
7. **RGAA Mapping** — map findings to RGAA criteria for French compliance

**iOS platform:**
1. **VoiceOver Support** — are `accessibilityLabel`, `accessibilityTraits`, and focus order specified?
2. **Dynamic Type** — does the feature support user-preferred text sizes?
3. **Reduced Motion** — does the feature respect `UIAccessibility.isReduceMotionEnabled`?
4. **Custom Actions** — do gesture-based interactions have non-gestural alternatives via `accessibilityCustomActions`?

**Android platform:**
1. **TalkBack Support** — are `contentDescription`, `Role` semantics, and traversal order specified?
2. **Font Scaling** — does the feature scale with system font size preferences?
3. **Touch Targets** — are interactive elements minimum 48x48dp?
4. **Reduced Motion** — does the feature respect `ANIMATOR_DURATION_SCALE`?

**Cross-platform (React Native):**
- Both iOS and Android checklists, plus: `accessibilityLabel`, `accessibilityRole`, `accessibilityState`, `accessibilityActions` props

**Cross-platform (Flutter):**
- Both iOS and Android checklists, plus: `Semantics` widget, `ExcludeSemantics`, `MergeSemantics`, semantic labels

**For all platforms:**
- **Compliance Acceptance Criteria** — derive concrete Given/When/Then scenarios for missing accessibility requirements

Present each section as a draft. Confirm before moving on.

### Step 9 — Run the Review (Deep Mode — DESIGN)

If reviewing a DESIGN:

1. **Color Contrast** — verify all color combinations against WCAG AA ratios (4.5:1 normal text, 3:1 large text)
2. **Component Accessibility** — for each component, check:
   - Keyboard interaction pattern (focus, activation, navigation within)
   - Screen reader announcement (role, name, state, value)
   - Touch target size (44x44px web, 48x48dp Android)
   - Visual focus indicator
3. **Page Layout Accessibility** — heading hierarchy, landmark regions, skip links
4. **User Flow Accessibility** — focus management during flow transitions, loading state announcements, error recovery
5. **Motion and Animation** — `prefers-reduced-motion` support, auto-playing content controls
6. **Form Accessibility** — label associations, error identification, input purpose (`autocomplete`)
7. **Platform-specific checks** — VoiceOver/TalkBack patterns if mobile design

Present findings grouped by component/page. Confirm before moving on.

### Step 10 — Run the Review (Verify Mode — PLAN)

If reviewing a PLAN:

1. **Testing Coverage** — check for accessibility testing steps:
   - Web: axe-core, Lighthouse, manual keyboard testing, screen reader testing
   - iOS: Accessibility Inspector, VoiceOver manual testing
   - Android: Accessibility Scanner, TalkBack manual testing
2. **Implementation Coverage** — cross-reference requirements from prior review against planned steps
3. **Missing Steps** — flag accessibility requirements with no corresponding implementation step
4. **Verification Items** — check the Verification Checklist for accessibility-specific items

Present findings as a gap report and confirm.

### Step 11 — Determine Output Path

The `ACCESSIBILITY-REVIEW.md` is **always** written to:

```
docs/features/{feature-name}/ACCESSIBILITY-REVIEW.md
```

Resolution logic follows the same pattern as other skills (derive from artifact location, create directory if needed, confirm before overwriting).

### Step 12 — Write the File

1. Assemble the complete `ACCESSIBILITY-REVIEW.md` using the template
2. Show the full content to the user for review
3. Ask: *"Ready to write this ACCESSIBILITY-REVIEW.md?"*
4. Write the file using the Write tool

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`.

### What to log

- **Platform detection** — how the platform was determined and which standards apply
- **Criterion interpretation** — when a WCAG criterion's applicability is ambiguous for the feature
- **Severity assessments** — when classifying a finding as critical vs. recommendation
- **Conflict resolutions** — when accessibility requirements conflict with design decisions

For entry format, shared exclusions, and writing rules, see `references/decision-log-format.md`.

---

## Rules

1. **Cite official standards** — every finding must reference the specific WCAG criterion, RGAA criterion, or platform guideline. Include the official source URL when consulted via WebSearch.
2. **Platform-aware** — always detect and adapt to the target platform. A web review checks ARIA; an iOS review checks VoiceOver; an Android review checks TalkBack. Never apply web-only standards to a native mobile feature.
3. **Flag, don't block** — the review identifies gaps and proposes ACs. It does not prevent the pipeline from proceeding.
4. **Concrete, not generic** — "improve accessibility" is not a finding. "Button component lacks `aria-label` — WCAG 4.1.2 Name, Role, Value" is a finding.
5. **Interactive and thorough** — confirm each section with the user before moving on.
6. **English always** — write the review in English regardless of conversation language.
7. **Prior review awareness** — when a prior review exists, highlight what's new vs. previously identified.
8. **Don't modify other artifacts** — this skill reads artifacts but never changes them.

---

## Pipeline Iteration

This skill can trigger upstream revisions when it finds accessibility gaps.

### When to Flag Upstream Issues

- **SPEC missing keyboard/screen reader ACs** — propose concrete Given/When/Then scenarios: *"These acceptance criteria should be added to the SPEC."*
- **DESIGN fails contrast requirements** — flag: *"Color combination {X} on {Y} fails WCAG AA (ratio: {N}:1, required: 4.5:1). The DESIGN should be updated."*
- **PLAN missing a11y testing steps** — flag: *"No accessibility testing steps in the PLAN. Consider adding {tool} testing."*

Findings are captured in ACCESSIBILITY-REVIEW.md. The user decides whether to act on them.

For the universal rollback protocol, see `references/pipeline-iteration.md`.

---

## Examples

### Example 1: Triage review of a BRIEF
User says: "Accessibility review on the checkout flow brief"
Actions:
1. Locate BRIEF, detect web platform (mentions React)
2. Triage: UI detected, forms (payment), error handling, navigation
3. Flag: form labels, payment field autocomplete, error announcements, focus management
4. Recommend 5 SPEC acceptance criteria
5. Write to `docs/features/checkout-flow/ACCESSIBILITY-REVIEW.md`
Result: Short triage with platform detection and 5 recommendations

### Example 2: Deep review of a mobile DESIGN
User says: "Check accessibility of the notification settings design"
Actions:
1. Locate DESIGN, detect React Native (cross-platform)
2. Deep mode: audit toggle components (VoiceOver/TalkBack labels, state announcements), list navigation (focus order), contrast checks
3. Find: 2 toggles lack accessibilityLabel, list items have no accessibilityRole, one color pair fails contrast
4. Produce 4 compliance ACs and 3 component-specific findings
5. Write to `docs/features/notification-settings/ACCESSIBILITY-REVIEW.md`
Result: Platform-specific audit covering both iOS and Android with 7 total findings

### Example 3: Deep review of a SPEC with RGAA mapping
User says: "WCAG review on the dashboard spec — we need RGAA compliance too"
Actions:
1. Locate SPEC, detect web platform
2. Deep mode: WCAG 2.1 AA audit across 4 User Stories
3. Map each finding to both WCAG criterion and RGAA criterion
4. Produce compliance ACs for keyboard nav, color contrast, screen reader announcements
5. Write to `docs/features/dashboard/ACCESSIBILITY-REVIEW.md`
Result: Dual WCAG/RGAA mapped review with 8 compliance ACs

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
