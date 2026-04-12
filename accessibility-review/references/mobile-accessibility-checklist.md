# Mobile Accessibility Review Checklist

Review framework for the `accessibility-review` skill — **native mobile platforms** (iOS, Android, cross-platform). Defines what to check per platform and component type. The actual guidelines are fetched live via `WebSearch`/`WebFetch`.

**Official sources for live lookup:**
- Apple HIG Accessibility: `https://developer.apple.com/design/human-interface-guidelines/accessibility`
- Apple Accessibility API: `https://developer.apple.com/documentation/accessibility`
- Android Accessibility Guide: `https://developer.android.com/guide/topics/ui/accessibility`
- Material Design Accessibility: `https://m3.material.io/foundations/accessibility/overview`
- WCAG2ICT (non-web ICT): `https://www.w3.org/TR/wcag2ict-22/`
- React Native Accessibility: `https://reactnative.dev/docs/accessibility`
- Flutter Accessibility: `https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility`

---

## iOS (VoiceOver) Checklist

### Labels and Traits

| Check | API | What to verify |
|---|---|---|
| accessibilityLabel | `accessibilityLabel` / `.accessibilityLabel()` | Every interactive element has a descriptive label |
| accessibilityHint | `accessibilityHint` / `.accessibilityHint()` | Complex actions have hints describing the result |
| accessibilityTraits | `UIAccessibilityTraits` / `.accessibilityAddTraits()` | Correct traits: `.button`, `.header`, `.selected`, `.adjustable`, `.link` |
| accessibilityValue | `accessibilityValue` / `.accessibilityValue()` | Sliders, steppers, progress indicators expose current value |

### Navigation and Focus

| Check | What to verify |
|---|---|
| Focus order | Logical reading order via `accessibilityElements` array or `.accessibilitySortPriority()` |
| Grouping | Related elements grouped with `.accessibilityElement(children: .combine)` |
| Custom actions | Gesture-based interactions have alternatives via `accessibilityCustomActions` |
| Modal behavior | Full-screen modals set `accessibilityViewIsModal = true` |
| Page changes | New screens announced via `UIAccessibility.post(notification: .screenChanged)` |

### Dynamic Type

| Check | What to verify |
|---|---|
| Font scaling | Text uses `UIFont.preferredFont(forTextStyle:)` or SwiftUI `.font(.body)` etc. |
| Layout adaptation | Content reflows without truncation at largest text sizes |
| Minimum size | No text below 11pt at default size |
| Images | Informational images scale or have text alternatives |

### Motion

| Check | What to verify |
|---|---|
| Reduced motion | Animations respect `UIAccessibility.isReduceMotionEnabled` |
| Auto-play | Auto-playing animations can be paused |
| Parallax | Parallax effects disabled when reduce motion is on |

### Color and Contrast

| Check | What to verify |
|---|---|
| Contrast ratio | 4.5:1 for normal text, 3:1 for large text (same as WCAG) |
| Color independence | Information not conveyed by color alone |
| Dark mode | Accessible contrast maintained in both light and dark appearances |

---

## Android (TalkBack) Checklist

### Content Descriptions

| Check | API | What to verify |
|---|---|---|
| contentDescription | `android:contentDescription` / `Modifier.contentDescription()` | Every interactive element has a description |
| importantForAccessibility | `android:importantForAccessibility` | Decorative elements marked `no`; important elements marked `yes` |
| Role semantics | `Role` in Compose (`Role.Button`, `Role.Checkbox`, `Role.Tab`, etc.) | Correct role for each interactive element |
| State descriptions | `stateDescription` | Toggles, checkboxes expose current state |

### Navigation and Focus

| Check | What to verify |
|---|---|
| Focus order | Logical order via `accessibilityTraversalBefore/After` or Compose semantics ordering |
| Headings | Section headings marked with `heading()` semantics |
| Custom actions | `AccessibilityAction` for complex gestures |
| Live regions | Dynamic content updates in `LiveRegion.Polite` or `LiveRegion.Assertive` |

### Touch Targets

| Check | What to verify |
|---|---|
| Minimum size | All interactive elements minimum 48x48dp |
| Spacing | Adequate spacing between touch targets to prevent accidental activation |
| Compose sizing | `Modifier.sizeIn(minWidth = 48.dp, minHeight = 48.dp)` |

### Font Scaling

| Check | What to verify |
|---|---|
| Scalable text | Text uses `sp` units (Compose) or `ScaleType` (XML) |
| Layout adaptation | Content reflows at 200% font scale |
| Non-text elements | Icons and controls remain usable at large font sizes |

### Motion

| Check | What to verify |
|---|---|
| Reduced motion | Animations check `Settings.Global.ANIMATOR_DURATION_SCALE` |
| Transition duration | Transitions respect system animation scale setting |

---

## Cross-Platform: React Native

In addition to both iOS and Android checklists above, check React Native-specific patterns:

| Check | API | What to verify |
|---|---|---|
| accessibilityLabel | `accessibilityLabel` prop | All interactive elements have a label |
| accessibilityRole | `accessibilityRole` prop | Correct role: `button`, `link`, `header`, `search`, `image`, `checkbox`, etc. |
| accessibilityState | `accessibilityState` prop | States communicated: `{ disabled, selected, checked, busy, expanded }` |
| accessibilityHint | `accessibilityHint` prop | Complex actions have hints |
| accessibilityActions | `accessibilityActions` + `onAccessibilityAction` | Custom actions for gesture alternatives |
| accessibilityLiveRegion | `accessibilityLiveRegion` prop | Dynamic content uses `polite` or `assertive` |
| importantForAccessibility | `importantForAccessibility` prop | Decorative elements set to `no-hide-descendants` |
| accessible | `accessible` prop | Container views group children when needed |

---

## Cross-Platform: Flutter

In addition to both iOS and Android checklists above, check Flutter-specific patterns:

| Check | API | What to verify |
|---|---|---|
| Semantics widget | `Semantics()` | Custom widgets wrapped with semantic information |
| label | `Semantics(label: ...)` | All interactive widgets have labels |
| excludeSemantics | `ExcludeSemantics` | Decorative widgets excluded from semantic tree |
| mergeSemantics | `MergeSemantics` | Related elements merged into single node |
| onTap / onLongPress | Semantics actions | Custom gestures have semantic action equivalents |
| textDirection | Semantics | RTL support for text direction |
| tooltip | `Tooltip` widget | Additional context via tooltips |

---

## Universal Mobile Checks

These apply to all mobile platforms:

| Check | Standard | What to verify |
|---|---|---|
| Color contrast | WCAG 1.4.3 / 1.4.11 | 4.5:1 normal text, 3:1 large text and UI components |
| Color independence | WCAG 1.4.1 | Information not conveyed by color alone |
| Text alternatives | WCAG 1.1.1 | Images, icons, charts have text alternatives |
| Error identification | WCAG 3.3.1 | Errors described in text, not just color |
| Gesture alternatives | WCAG 2.5.1 | Multi-point or path-based gestures have single-pointer alternatives |
| Motion actuation | WCAG 2.5.4 | Motion-triggered actions can be disabled |
| Target size | WCAG 2.5.5 (AAA) / 2.5.8 (AA in 2.2) | Touch targets meet platform minimum (44pt iOS, 48dp Android) |
| Orientation | WCAG 1.3.4 | Content works in both orientations |
