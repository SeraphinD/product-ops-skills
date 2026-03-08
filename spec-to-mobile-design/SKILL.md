---
name: spec-to-mobile-design
description: Transforms a SPEC.md into a structured DESIGN.md for native mobile app features (iOS and Android) — covering platform-specific design tokens (colors, typography in pt/dp/sp, spacing), native components with states and variants, screen layouts with ASCII wireframes, navigation patterns, user flows, gestures and haptics, and accessibility requirements for both VoiceOver (iOS) and TalkBack (Android). Trigger on phrases like "mobile design from spec", "create mobile design", "spec to mobile design", "native app design", "iOS design from spec", "Android design from spec", "design the mobile app", "mobile UI design", "app screen design", "React Native design", "Flutter design", "SwiftUI design", "Jetpack Compose design", or when the user has a SPEC.md and the feature targets native mobile platforms — even if they say just "design" but the spec clearly describes a mobile app. Do NOT use for web or responsive web features (use spec-to-design instead), backend-only features, CLI tools, or API-only services. Do NOT use for generating implementation plans (use spec-to-plan) or task lists (use plan-to-tasks).
allowed-tools: "Read Write Glob Grep"
license: MIT
metadata:
  author: seraphindesumeur
  version: 1.0.0
  category: feature-pipeline
  tags: [design, mobile, ios, android, native, react-native, flutter, swiftui, jetpack-compose, accessibility]
---

# SPEC → MOBILE DESIGN Skill

This skill transforms a `SPEC.md` into a structured `DESIGN.md` — a native mobile app design document covering platform-specific design tokens, native components, screen layouts, navigation patterns, user flows, gestures, haptics, and accessibility for both iOS and Android.

This is the **optional design phase** of the feature pipeline, specifically for native mobile features:

```
BRIEF.md → [BENCHMARK.md] → SPEC.md → [DESIGN.md] → PLAN.md → TASKS.md
```

Its purpose is to ensure mobile features have a concrete, reviewable design specification — grounded in iOS Human Interface Guidelines and Material Design 3 — before implementation planning begins. Users can skip this phase and go directly from SPEC to PLAN. This skill exists for when the feature targets native mobile platforms and the team wants design decisions documented upfront.

**When to use this skill vs spec-to-design:** Use this skill when the feature is a native mobile app (iOS, Android, or cross-platform via React Native / Flutter / Expo). Use `spec-to-design` when the feature is a web application (even if it's responsive or mobile-friendly in a browser). If the feature has both a web and native mobile component, run both skills — they produce separate design documents.

---

## Output Template

**Before writing any output, read `references/template.md` for the exact DESIGN.md structure.**

The DESIGN contains: Design Overview, Design Goals, Platform Strategy, Design System (Color Palette with platform tokens, Typography in pt/dp/sp, Spacing & Safe Areas), Native Components (with states/variants/platform differences/accessibility), Screen Layouts (with ASCII wireframes per platform), Navigation Architecture, User Flows, Gestures & Haptics, Interactions & Animations, Accessibility Requirements (VoiceOver + TalkBack), optional Dark Mode (via system appearance), Adaptive Layout Details, and a Checklist for Design Approval.

**After writing, run `bash scripts/validate-mobile-design.sh {path-to-design}` to verify structural completeness.**

---

## Interaction Protocol

Work section by section. For each section:
1. Share what you've derived from the spec
2. Propose a draft of the section
3. Ask for confirmation or adjustments before moving on
4. Never skip a section — if you can't write it confidently from the spec, ask a targeted question

**Never generate the full DESIGN in one shot without confirming each major block** (Platform Strategy, Design System, Components, Screen Layouts, Navigation, User Flows, Gestures, Accessibility) with the user first.

---

## Step-by-Step Process

### Step 1 — Locate the SPEC

Find the specification file. Look in this order:
1. The path the user provides directly
2. `docs/features/*/SPEC.md` matching any feature name in context
3. Any `SPEC.md` in the current working directory

Read the file in full. If no SPEC is found, ask the user to provide the path or paste the content.

When reading User Stories, extract the MoSCoW label from each header (e.g., `## User Story 1 — MUST`). Group them mentally before proceeding:
- **MUST** — full design treatment (all states, variants, wireframes per platform, flows)
- **SHOULD** — moderate design treatment (components, layouts, key states)
- **COULD** — minimal design treatment (mentioned in overview, component stubs with a note that detailed design is deferred)
- **WON'T** — excluded; do not design anything for WON'T stories

If the SPEC has no MoSCoW labels, treat all User Stories as MUST and proceed normally.

---

### Step 2 — Load Prior Decisions

Before generating anything, check whether a `DECISION.md` exists in the same `docs/features/{feature-name}/` directory as the SPEC.

If it exists, read it in full. Then:
- **Treat every Accepted decision as a hard constraint** — do not re-open, re-ask, or contradict it.
- If a prior decision directly conflicts with a design choice, flag the conflict to the user before proceeding: *"Decision {N} says X, but the design would benefit from Y. Which should take precedence?"*
- Do not log prior decisions again — only log new decisions made during this skill's execution.

---

### Step 3 — Load BRIEF (context)

Check whether a `BRIEF.md` exists in the same `docs/features/{feature-name}/` directory.

If it exists, read it for contextual information:
- **Problem Statement** → informs Design Overview (what pain the app must address)
- **Solution** → informs Design Goals (the core design principle)
- **Key Objectives** → informs Design Goals (what the app must achieve)
- **Success Criteria** → informs measurable design targets

If no BRIEF is found, proceed with SPEC data only.

---

### Step 4 — Load Benchmark Visual References (if available)

Check whether a `BENCHMARK.md` exists in the same `docs/features/{feature-name}/` directory.

If it exists, read it and extract:
- **Visual References** → competitor app layout patterns and user flow diagrams become reference material. Use as inspiration, never copy.
- **Technical Standards** → any design-related standards (e.g., HIG, Material Design, WCAG) inform Accessibility Requirements and Design System.
- **Spec Recommendations** → design-relevant "Include" or "Exclude" items.

If no BENCHMARK.md exists, proceed without it — this input is optional.

---

### Step 5 — Detect Mobile Feature

This skill only applies to features targeting native mobile platforms. Before proceeding, verify the SPEC describes a mobile feature.

**Detection logic:**

1. Scan the SPEC for mobile indicators: mobile, app, iOS, Android, iPhone, iPad, phone, tablet, native, SwiftUI, UIKit, Jetpack Compose, Kotlin, Swift, React Native, Flutter, Expo, Dart, screen, navigation stack, tab bar, bottom sheet, push notification, gesture, swipe, tap, haptic, touch, safe area, notch, Dynamic Island, status bar, home indicator, App Store, Play Store, widget, deep link.
2. Also check the BRIEF (if loaded) for tech stack mentions.
3. Classification:
   - **Clearly mobile** → proceed normally
   - **Clearly web** → inform the user: *"This SPEC appears to describe a web feature. DESIGN.md is for native mobile apps. Did you mean to use spec-to-design instead?"*
   - **Ambiguous** → ask: *"I'm not sure if this feature targets native mobile or web. Is this a native app (iOS/Android/React Native/Flutter)? If yes, I'll create a DESIGN.md."*

Log the feature type detection to `DECISION.md`.

---

### Step 6 — Detect Existing Design System

Before asking the user anything about design tokens, proactively scan the codebase for an existing mobile design system. **See `references/platforms.md` → "Design System Detection Patterns" for per-platform file patterns and package names to search for (React Native, Flutter, iOS, Android).**

**What to do with findings:**

- **Existing design system found** → store the extracted values internally. In Step 9, **reuse them as-is** instead of proposing new ones. Inform the user: *"I found an existing design system in `{path}`. I'll extend it rather than create a new one."* Log this to `DECISION.md`.
- **UI library detected but no custom tokens** → note the library. In Step 9, propose tokens that align with the library's conventions. Inform the user: *"The project uses {library}. I'll align the design system with its conventions."*
- **Nothing found** → proceed normally. Step 9 will propose a new design system from scratch.

---

### Step 7 — Analyze gaps before writing

After reading the SPEC and scanning the codebase (Step 6), scan for remaining information needed to write a complete mobile design document:

- **Target platforms** — iOS only? Android only? Both? Cross-platform framework?
- **Framework** — SwiftUI, UIKit, Jetpack Compose, XML Views, React Native, Flutter, Expo?
- **Screens** — Are specific screens or views mentioned or implied?
- **Navigation pattern** — Tab-based? Stack-based? Drawer? Mentioned in the spec?
- **Gestures** — Does the spec imply swipe, long-press, pull-to-refresh, or custom gestures?
- **Permissions** — Does the feature require camera, location, notifications, or other system permissions?
- **Dark mode** — Should the app follow system appearance? Is it mentioned?
- **Accessibility** — Any requirements beyond the default VoiceOver/TalkBack support?
- **Offline behavior** — Does the spec mention offline capabilities or data persistence?

If you find ambiguities, **ask all clarifying questions in a single message** — group them by topic, be specific, and propose a default answer when you have a reasonable one. Do not proceed to writing until the user has answered.

If the SPEC is complete enough to write every section without inventing details, skip straight to Step 8.

**Example of a good clarifying message (React Native project found):**

> Before I write the DESIGN, I have a few gaps:
>
> **Platforms** — I found a React Native project. I'll design for both iOS and Android, noting platform differences where they diverge. OK?
>
> **Navigation** — The SPEC has 4 user stories implying at least 3 screens, but doesn't specify navigation style. I'll default to a bottom tab bar with stack navigation inside each tab. Does that work?
>
> **Dark mode** — Not mentioned in the SPEC. I'll design for system appearance (light/dark follows device settings). OK, or skip dark mode entirely?

**Example of a good clarifying message (greenfield project):**

> Before I write the DESIGN, I have a few gaps:
>
> **Framework** — The SPEC doesn't mention a specific framework. Are you building with SwiftUI, Jetpack Compose, React Native, Flutter, or something else?
>
> **Platforms** — iOS only, Android only, or both?
>
> **Design system** — I didn't find an existing design system. I'll create one from scratch following iOS HIG and Material Design 3 conventions. Any preferences?

---

### Step 8 — Design Overview, Goals, and Platform Strategy

Derive the Design Overview from:
- SPEC overview and user story benefits
- BRIEF problem statement and solution (if loaded)
- BENCHMARK gap analysis (if loaded)

Write 3–6 Design Goals that are:
- Concrete and tied to SPEC user stories or functional scope
- Not generic ("clean design", "modern feel" are not acceptable)
- Verifiable — someone can check whether the goal was met

Define the **Platform Strategy**:
- Which platforms are targeted (iOS, Android, or both)
- Whether the design is unified (one design for both) or platform-native (follows each platform's conventions separately)
- The framework being used and how it affects design decisions (e.g., Flutter uses Material by default, SwiftUI uses HIG by default, React Native can go either way)

This matters because iOS and Android have genuinely different design languages. A SwiftUI app should feel like an iOS app (rounded rectangles, SF Symbols, sheets sliding up from the bottom). A Jetpack Compose app should feel like an Android app (Material 3 components, top app bars, floating action buttons). Cross-platform frameworks like React Native and Flutter need a conscious choice — follow one platform's conventions, or adapt per platform.

Propose a draft. Ask for confirmation.

---

### Step 9 — Define the Design System

Generate Color Palette, Typography, and Spacing & Safe Areas — with platform-specific tokens.

**Rules:**
- **If Step 6 found an existing design system, you MUST reuse it.** Import the detected values directly into the Design System section. Do not propose alternatives for values that already exist — only extend with new tokens the feature requires. Clearly mark which values are inherited (`Existing`) vs new (`New`).
- If Step 6 detected a UI library but no custom tokens, align proposed values with the library's conventions and defaults
- If Step 6 found nothing, propose a minimal, accessible palette from scratch and confirm with the user
- All colors must meet WCAG 2.1 AA contrast ratios (4.5:1 for normal text, 3:1 for large text)
- **Typography must use platform-native units:** pt for iOS, sp for Android text, dp for Android non-text elements. Include the font families that are default for each platform (SF Pro for iOS, Roboto for Android) unless the project uses custom fonts.
- **Spacing must use platform-native units:** pt for iOS, dp for Android. Define safe area insets (top for status bar / Dynamic Island / notch, bottom for home indicator / navigation bar).
- All values must be concrete — hex codes, specific sizes and weights. No vague entries.

For **cross-platform frameworks** (React Native, Flutter), present values in the framework's native format (e.g., Flutter uses logical pixels, React Native uses density-independent pixels that map to pt/dp) and note how they translate to each platform.

Propose a draft. Ask for confirmation.

---

### Step 10 — Design Native Components (MoSCoW-aware)

For each User Story in the SPEC (excluding WON'T), extract implied components from the functional scope. Tag each component with its source story and MoSCoW label.

**Use native component vocabulary** — not web component names. **See `references/platforms.md` → "Component Vocabulary Mapping" for the full web → iOS → Android translation table.**

When a component differs significantly between platforms, document both variants. When functionally identical, document once and note "same on both platforms."

**Treatment depth by MoSCoW:**

| Label | Treatment |
|-------|-----------|
| **MUST** | Full — all states, variants, platform differences, ASCII wireframe if complex, usage, accessibility |
| **SHOULD** | Moderate — states, usage, accessibility. Variants if clearly implied. |
| **COULD** | Minimal — name, brief description, source story, note: *"Detailed design deferred — implement if COULD phase is kept."* |

Do not design components for WON'T stories.

Propose components in batches (group by source story). Confirm each batch before moving on.

---

### Step 11 — Design Screen Layouts

For each distinct screen implied by the SPEC:

1. Draw an ASCII box-drawing diagram showing component placement. If iOS and Android layouts differ materially (e.g., iOS uses a bottom tab bar while Android uses a top app bar + bottom navigation bar), draw separate diagrams for each platform.
2. List key elements with their location and purpose.
3. Include safe area considerations (status bar, notch/Dynamic Island, home indicator).
4. Tag with source story and MoSCoW label.

Apply the same MoSCoW depth as components: MUST screens get full layouts, SHOULD screens get moderate layouts, COULD screens get stubs.

Propose each layout as a draft. Confirm before moving on.

---

### Step 12 — Define Navigation Architecture

Mobile navigation is structural — it shapes the entire app experience. Define:

1. **Navigation pattern** — Tab-based, stack-based, drawer, or hybrid. State which pattern and why it fits the spec's user stories.
2. **Navigation hierarchy** — ASCII diagram showing the screen graph (which screens link to which). Include back navigation behavior.
3. **Deep linking** — If the spec mentions deep links, URL schemes, or universal links, define the routes.
4. **Tab bar / bottom navigation** — If used, list tabs with icons and labels. Note badge behavior if applicable.

Use ASCII to diagram the navigation graph:

```
[Tab: Home] → [Detail Screen] → [Edit Screen]
[Tab: Search] → [Results] → [Detail Screen]
[Tab: Profile] → [Settings]
```

Propose a draft. Confirm.

---

### Step 13 — Define User Flows

For each acceptance criteria scenario in the SPEC that involves user interaction:

1. Derive a user flow showing the step-by-step interaction
2. Include the success path and at least one error/edge-case path
3. Use ASCII flow diagrams
4. Tag with source story
5. **Include system permission prompts** where relevant (camera, location, notifications). Show the permission request as a flow step with both "Allow" and "Don't Allow" paths.

Focus on flows that involve multiple steps or decision points. Single-action scenarios (e.g., "tap button then see result") don't need a flow diagram.

Propose the flows. Confirm before moving on.

---

### Step 14 — Define Gestures & Haptics

Mobile apps rely on gestures and haptic feedback in ways web apps don't. Define:

**Gestures:**
- Which screens or components respond to swipe, long-press, pinch, pull-to-refresh, or other gestures
- What each gesture triggers (e.g., "swipe left on list item reveals delete action")
- Edge cases: what happens at list boundaries, during loading states, or when a gesture conflicts with system gestures (e.g., swipe-from-edge for back navigation on iOS)

**Haptics (iOS) / Vibration (Android):**
- Which interactions trigger haptic feedback and what type. See `references/platforms.md` → "Haptic Feedback APIs" for iOS `UIImpactFeedbackGenerator` and Android `HapticFeedbackConstants` reference.
- Keep this minimal unless the spec explicitly calls for rich haptic patterns

If the spec implies no custom gestures or haptics, state that and move on — don't invent requirements.

Propose a draft. Confirm.

---

### Step 15 — Define Interactions & Animations

Cover screen transitions, touch feedback, loading states, and error state animations.

**Rules:**
- Default to platform conventions: iOS uses fluid push/pop transitions and sheets; Android uses Material motion patterns (container transform, shared axis, fade through)
- Keep minimal unless the SPEC explicitly requires rich animations
- For COULD stories, omit interaction details or add a stub
- Specify concrete values: duration in ms, easing function, animation type
- Note `UIAccessibility.isReduceMotionEnabled` (iOS) / `Settings.Global.ANIMATOR_DURATION_SCALE` (Android) considerations

Propose a draft. Confirm.

---

### Step 16 — Define Accessibility Requirements

Mobile accessibility spans both platform-specific assistive technologies and universal standards. **See `references/platforms.md` → "Accessibility Checklists" for the full VoiceOver (iOS), TalkBack (Android), and Universal checklists.**

Key minimums to always enforce:
- All interactive elements labelled (VoiceOver `accessibilityLabel` / TalkBack `contentDescription`)
- Touch targets ≥ 44×44pt (iOS) / 48×48dp (Android)
- WCAG 2.1 AA contrast: 4.5:1 normal text, 3:1 large text
- Dynamic Type (iOS) / system font scale (Android) respected
- Reduced motion respected on both platforms

Add SPEC-specific accessibility items derived from the functional scope and acceptance criteria. If BENCHMARK.md mentioned accessibility standards, incorporate them.

Propose a draft. Confirm.

---

### Step 17 — Dark Mode and Adaptive Layout

**Dark Mode:**
- Mobile apps typically follow system appearance (light/dark mode set at the OS level)
- Only include this section if the SPEC, BRIEF, or user mentions dark mode, OR if the platform strategy targets both appearances (the default for modern iOS and Android apps)
- If included, use semantic color tokens — see `references/platforms.md` → "Dark Mode Token Mapping" for iOS semantic colors and Android Material 3 role-based tokens
- If not in scope, add a note: *"Dark mode: Not in scope for this version. The app uses light appearance only."*

**Adaptive Layout:**
- Define behavior across: Compact (small phones), Standard (typical phones), Large (max-size phones), and Tablet (only if spec mentions it)
- Specify orientation support: portrait only, or portrait + landscape?
- For API references, see `references/platforms.md` → "Adaptive Layout APIs" (iOS Size Classes, Android Window Size Classes)

Propose a draft. Confirm.

---

### Step 18 — Design Decisions & Rationale

Summarize the key design choices made during this interaction. These complement the DECISION.md entries but are embedded in the DESIGN.md for readers who don't check the decision log.

For each notable choice:
- What was decided
- Why (reasoning)
- What alternatives were considered
- Impact on UX

Keep this section concise — 3–6 decisions that genuinely shape the design.

---

### Step 19 — Determine Output Path

The `DESIGN.md` is **always** written to:

```
docs/features/{feature-name}/DESIGN.md
```

Where `{feature-name}` is the kebab-case version of the feature name.

**Resolution logic:**

1. If the SPEC is already inside `docs/features/{feature-name}/`, write the DESIGN to the same directory.
2. Otherwise, derive `{feature-name}` from the spec's title and write to `docs/features/{feature-name}/DESIGN.md` in the current working directory.
3. Create the directory if it does not exist.
4. If a `DESIGN.md` already exists at that path, confirm with the user before overwriting.
5. Never ask the user where to save — always derive the path. Inform the user before writing: *"I'll write the DESIGN to `docs/features/{feature-name}/DESIGN.md`."*

---

### Step 20 — Write the File

Once all sections are confirmed:
1. Assemble the complete `DESIGN.md` using the template
2. Show a summary: *"Here's the full DESIGN.md — {N} components, {M} screen layouts, {K} user flows, targeting {platforms}. Ready to write it to `{path}`?"*
3. Wait for confirmation
4. Write the file using the Write tool
5. Confirm: *"Done — `DESIGN.md` written to `{path}`."*

---

## Decision Logging

Throughout the interaction, log every non-obvious decision to `docs/features/{feature-name}/DECISION.md`. Create the file if it does not exist. Append new decisions — never overwrite existing ones.

### What to log

- **Design decisions** — color choices, typography selections, component patterns, navigation approach, gesture strategy, platform-specific choices
- **Explicit decisions** — choices the user made when you asked a clarifying question (e.g., target platforms, framework, dark mode inclusion, navigation pattern)
- **Implicit decisions** — choices you made without asking because the spec was clear enough (e.g., inferring a component from an acceptance criterion, choosing tab-based navigation)
- **Scope decisions** — omitting Dark Mode, deferring a COULD component's detailed design, including/excluding tablet support
- **Platform decisions** — choosing to follow iOS conventions vs Android conventions, using platform-native vs unified design

### What NOT to log

- Obvious, mechanical actions (e.g., "wrote the file", "drew an ASCII diagram")
- Formatting or template-structure decisions already defined by this skill
- Design Decisions already captured in the DESIGN.md's "Design Decisions & Rationale" section (avoid duplication)

### Entry format

```markdown
## Decision {N}: {Short title}
**Status:** Accepted | **Date:** {YYYY-MM-DD} | **Skill:** spec-to-mobile-design

### Context
{What was being decided and why}

### Decision
**{One-sentence statement}**

### Rationale
{Numbered list of reasons}

### Options Considered *(omit for simple decisions)*
| Option | Pros | Cons |
|--------|------|------|
| **{Chosen}** | {pros} | {cons} |
```

Append decisions as they happen — do not batch at the end. This ensures the log is complete even if the session is interrupted.

---

## Rules

1. **Traceable to the spec** — every component, layout, flow, and design choice must be grounded in the spec's user stories and functional scope. Do not invent UI elements not implied by the spec.
2. **Mobile only** — this skill produces design documents for native mobile apps. If the spec does not describe a mobile feature, inform the user and suggest using `spec-to-design` for web or skipping to PLAN.
3. **Platform-native by default** — use each platform's native design language (HIG for iOS, Material Design 3 for Android). Cross-platform frameworks should still respect platform conventions unless the user explicitly chooses a unified design.
4. **Accessible by default** — all colors must meet WCAG 2.1 AA contrast ratios. All interactive elements must document VoiceOver and TalkBack support. Touch targets must meet platform minimums (44x44pt iOS, 48x48dp Android).
5. **MoSCoW-aware depth** — MUST stories get full design treatment (all states, variants, wireframes per platform). SHOULD stories get moderate treatment. COULD stories get minimal stubs. WON'T stories are never designed.
6. **No filler** — do not add design elements that are generic best practices not grounded in the spec. Every component and layout must serve a spec-derived purpose.
7. **English always** — write the DESIGN.md in English regardless of the language used in the conversation.
8. **Interactive and thorough** — scan the spec for gaps before writing. Ask all clarifying questions upfront in a single message, grouped by topic. Then propose each major section as a draft and confirm with the user before moving on. Do not generate the full DESIGN in one shot without section-by-section confirmation.
9. **Benchmark-informed, not benchmark-bound** — if BENCHMARK.md visual references exist, use them as inspiration but never copy competitor app designs. Propose original designs informed by research.
10. **Concrete, not aspirational** — ASCII diagrams must show specific component placement. Color values must include hex codes. Typography must include specific sizes and weights in platform-native units. Avoid vague entries like "clean design" or "modern feel".

---

## Examples

### Example 1: React Native app with existing theme
User: *"Design the mobile app for the notifications feature"*
→ Find SPEC, detect React Native + existing theme in `src/theme/tokens.ts` → inform user, extend it → design 5 native components (NotificationListItem, NotificationBadge, FilterChip, EmptyState, PermissionPrompt) → draw 3 screen layouts with platform differences → tab bar + stack navigation → swipe-to-dismiss + pull-to-refresh gestures → write `docs/features/notifications/DESIGN.md`

### Example 2: Greenfield SwiftUI app, iOS only
User: *"Create mobile design from our onboarding spec"*
→ Find SPEC, detect Swift project, no existing design system → ask: *"I'll follow iOS HIG with SF Pro and system colors. OK?"* → design with SwiftUI vocabulary (NavigationStack, Sheet, Toggle) → safe area insets for notch + home indicator → onboarding flow with permission prompts (notifications, camera) → write `docs/features/onboarding/DESIGN.md`

---

## Troubleshooting

For common issues and solutions, consult `references/troubleshooting.md`.
