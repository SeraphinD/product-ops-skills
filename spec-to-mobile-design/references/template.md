# MOBILE-DESIGN.md Output Template

The final `MOBILE-DESIGN.md` must follow **exactly** this structure:

```markdown
# Mobile Design: {Feature Name}

> Generated from: {relative path to SPEC.md}
> Date: {YYYY-MM-DD}
> Platforms: {iOS | Android | iOS + Android}
> Framework: {SwiftUI | UIKit | Jetpack Compose | React Native | Flutter | Expo | other}

---

## Design Overview
{Brief overview of the mobile design approach — derived from SPEC user stories and functional scope}

## Design Goals
<!-- 3 to 6 goals -->
- {Goal 1 — tied to a SPEC user story benefit or functional requirement}
- {Goal 2}
- {Goal 3}
- ...

## Platform Strategy
- **Target platforms:** {iOS, Android, or both}
- **Design approach:** {Unified (one design for both) | Platform-native (follows each platform's conventions)}
- **Framework:** {Framework name and how it affects design decisions}
- **Design references:** {iOS HIG | Material Design 3 | both}

---

## Design System

### Color Palette
| Role | Color | Hex | iOS Token | Android Token | Contrast Ratio |
|------|-------|-----|-----------|---------------|----------------|
| **Primary** | {Color name} | `#XXXXXX` | {e.g., `.tint` or custom} | {e.g., `md_theme_primary`} | {ratio} >= 4.5:1 |
| **Secondary** | {Color name} | `#XXXXXX` | {iOS token} | {Android token} | {ratio} >= 4.5:1 |
| **Success** | {Color name} | `#XXXXXX` | {iOS token} | {Android token} | {ratio} >= 4.5:1 |
| **Error** | {Color name} | `#XXXXXX` | {iOS token} | {Android token} | {ratio} >= 4.5:1 |
| **Background** | {Color name} | `#XXXXXX` | {e.g., `systemBackground`} | {e.g., `md_theme_surface`} | — |
| **Surface** | {Color name} | `#XXXXXX` | {iOS token} | {Android token} | — |
| **On Primary** | {Color name} | `#XXXXXX` | {iOS token} | {Android token} | {ratio} >= 4.5:1 |

### Typography
| Element | Font (iOS) | Size (pt) | Font (Android) | Size (sp) | Weight | Usage |
|---------|-----------|-----------|----------------|-----------|--------|-------|
| **Large Title** | SF Pro Display | 34pt | Roboto | 34sp | Bold | Screen titles |
| **Title** | SF Pro | 22pt | Roboto | 22sp | Bold | Section headers |
| **Headline** | SF Pro | 17pt | Roboto | 16sp | Semibold | Card titles |
| **Body** | SF Pro | 17pt | Roboto | 16sp | Regular | Paragraph text |
| **Callout** | SF Pro | 16pt | Roboto | 14sp | Regular | Secondary info |
| **Caption** | SF Pro | 12pt | Roboto | 12sp | Regular | Labels, timestamps |
| **Button** | SF Pro | 17pt | Roboto Medium | 14sp | Semibold | Button labels |

### Spacing & Safe Areas
- **Base Unit:** {e.g., 8pt / 8dp}
- **Spacing Scale:** {e.g., 4, 8, 12, 16, 24, 32, 48}
- **Safe Areas:**
  - iOS top: {e.g., 59pt (iPhone with Dynamic Island), 47pt (iPhone with notch), 20pt (no notch)}
  - iOS bottom: {e.g., 34pt (home indicator), 0pt (home button)}
  - Android top: {e.g., 24dp (status bar)}
  - Android bottom: {e.g., 48dp (3-button nav), 0dp (gesture nav)}
- **Touch Targets:**
  - iOS minimum: 44x44pt
  - Android minimum: 48x48dp

---

## Native Components

### {Component Name}
**Source Story:** User Story {N} — {MUST | SHOULD | COULD}
**States:** {default, pressed, disabled, loading, error, ...}
**Variants:** {primary, secondary, destructive, ...}

**iOS Implementation:**
- Native equivalent: {e.g., List with .swipeActions, NavigationLink}
- {iOS-specific behavior or appearance}

**Android Implementation:**
- Native equivalent: {e.g., LazyColumn with SwipeToDismiss, Material 3 ListItem}
- {Android-specific behavior or appearance}

```
{ASCII wireframe of the component if complex — show both platforms if they differ}
```

**Usage:** {When and where to use this component}
**Accessibility:**
- VoiceOver: {accessibilityLabel, traits, custom actions}
- TalkBack: {contentDescription, role, actions}

{repeat for each component derived from SPEC functional scope}

---

## Screen Layouts

### {Screen Name}: {Purpose}
**Source Story:** User Story {N} — {MUST | SHOULD | COULD}
**Route / Deep Link:** {Route if applicable, e.g., /notifications/:id}
**Description:** {What this screen does}

#### iOS Layout
```
{ASCII box-drawing diagram with safe areas, navigation bar, content, tab bar}
```

#### Android Layout
```
{ASCII box-drawing diagram with status bar, top app bar, content, bottom navigation}
```

**Key Elements:**
- {Component 1: location and purpose}
- {Component 2: location and purpose}

**Safe Area Considerations:**
- {How content relates to status bar, notch, home indicator}

{repeat for each screen}

---

## Navigation Architecture

### Navigation Pattern
- **Type:** {Tab-based | Stack-based | Drawer | Hybrid}
- **Rationale:** {Why this pattern fits the spec's user stories}

### Screen Graph
```
{ASCII diagram showing navigation hierarchy}
[Tab: Home] --> [Detail] --> [Edit]
[Tab: Search] --> [Results] --> [Detail]
[Tab: Profile] --> [Settings]
```

### Tab Bar / Bottom Navigation
| Tab | Label | Icon | Badge |
|-----|-------|------|-------|
| {Tab 1} | {Label} | {Icon name — SF Symbol for iOS, Material Icon for Android} | {Badge behavior or "none"} |
| {Tab 2} | {Label} | {Icon name} | {Badge behavior or "none"} |

### Deep Links *(if applicable)*
| Route | Screen | Parameters |
|-------|--------|------------|
| {URL scheme or universal link} | {Target screen} | {Parameters} |

---

## User Flows

### {Flow Name}: {User Goal}
**Source Story:** User Story {N} — {MUST | SHOULD | COULD}

```
{ASCII flow diagram: Start --> Step 1 --> Step 2 --> Success}
                                   |
                             Error Handling
```

**Steps:**
1. User performs {action}
2. System shows {feedback}
3. {Permission prompt if applicable: "Allow" path and "Don't Allow" path}
4. Success condition: {what success looks like}

**Error Path:**
- {Error condition}: {what happens}

{repeat for each major user flow}

---

## Gestures & Haptics

### Gestures
| Screen / Component | Gesture | Action | Edge Cases |
|---|---|---|---|
| {target} | {swipe left, long-press, pull-down, pinch, etc.} | {what it triggers} | {boundary behavior, conflicts with system gestures} |

### Haptics
| Interaction | iOS (UIImpactFeedbackGenerator) | Android (HapticFeedbackConstants) |
|---|---|---|
| {e.g., successful action} | {e.g., .medium impact} | {e.g., CONFIRM} |
| {e.g., error} | {e.g., .error notification} | {e.g., REJECT} |
| {e.g., selection change} | {e.g., .selection changed} | {e.g., CLOCK_TICK} |

---

## Interactions & Animations

### Screen Transitions
- **iOS:** {e.g., push/pop (NavigationStack default), sheet presentation (.sheet modifier)}
- **Android:** {e.g., Material shared axis (forward/backward), container transform}
- **Duration:** {ms}

### Touch Feedback
- **iOS:** {e.g., highlight state, spring animation on press}
- **Android:** {e.g., ripple effect (Material 3 default)}

### Loading States
- **Spinner:** {When to use — e.g., full-screen initial load}
- **Skeleton:** {When to use — e.g., content placeholders during refresh}
- **Pull-to-refresh:** {e.g., native RefreshControl on iOS, SwipeRefresh on Android}

### Error States
- **Animation:** {e.g., shake on invalid input}
- **Message placement:** {e.g., inline below field, or alert/snackbar}
- **Auto-dismiss:** {Duration or manual dismiss}

### Reduced Motion
- iOS: check `UIAccessibility.isReduceMotionEnabled`
- Android: check `Settings.Global.ANIMATOR_DURATION_SCALE`
- Behavior when enabled: {e.g., replace animations with instant transitions}

---

## Accessibility Requirements

### iOS (VoiceOver)
- [ ] All interactive elements have `accessibilityLabel`
- [ ] Custom components implement proper accessibility elements
- [ ] Logical focus order defined
- [ ] Dynamic Type supported — text scales with user preferences
- [ ] `accessibilityTraits` correctly set (button, header, selected, adjustable)
- [ ] Custom actions for swipe gestures have non-gestural alternatives
{add feature-specific iOS accessibility items}

### Android (TalkBack)
- [ ] All interactive elements have `contentDescription`
- [ ] `importantForAccessibility` correctly configured
- [ ] Logical focus order defined
- [ ] Text scales with system font size preferences
- [ ] Correct semantics roles (Button, Checkbox, Tab, etc.)
- [ ] Touch targets minimum 48x48dp
{add feature-specific Android accessibility items}

### Universal
- [ ] WCAG 2.1 Level AA compliance target
- [ ] Color contrast minimum 4.5:1 for normal text, 3:1 for large text
- [ ] No information conveyed by color alone
- [ ] Error messages associated with their inputs
- [ ] Loading states announced to screen readers
- [ ] Reduced motion respected on both platforms

---

## Dark Mode *(if applicable)*

### Color Mapping
| Element | Light Mode | Dark Mode | iOS Semantic | Android Token |
|---------|-----------|-----------|--------------|---------------|
| Background | {Color} | {Color} | `systemBackground` | `md_theme_surface` |
| Surface | {Color} | {Color} | `secondarySystemBackground` | `md_theme_surfaceContainer` |
| Text Primary | {Color} | {Color} | `label` | `md_theme_onSurface` |
| Text Secondary | {Color} | {Color} | `secondaryLabel` | `md_theme_onSurfaceVariant` |
| Accent | {Color} | {Color} | `.tint` | `md_theme_primary` |

### Implementation Notes
- **iOS:** follow system appearance via `UIUserInterfaceStyle` / `.preferredColorScheme()`
- **Android:** follow system via `isSystemInDarkTheme()` / `AppCompatDelegate.setDefaultNightMode()`
- **Persistence:** {Follow system | User toggle | Always light}

---

## Adaptive Layout

### Device Categories
| Category | Width | Examples | Layout Adjustments |
|----------|-------|---------|-------------------|
| **Compact** | < 375pt / < 360dp | iPhone SE, small Android | {adjustments} |
| **Standard** | 375–428pt / 360–412dp | iPhone 15, typical Android | {default design} |
| **Large** | > 428pt / > 412dp | iPhone 15 Pro Max, large Android | {adjustments} |
| **Tablet** | > 768pt / > 600dp | iPad, Android tablet | {adjustments — only if in scope} |

### Orientation
- **Supported:** {Portrait only | Portrait + Landscape}
- **Landscape behavior:** {if supported — layout changes, component reflow}

---

## Design Files & References

- **Figma:** {Link or "N/A — design defined in this document"}
- **Design System:** {Link to external system or "Defined above"}
- **iOS HIG Reference:** {Specific HIG pages consulted, or "General HIG compliance"}
- **Material Design 3 Reference:** {Specific MD3 pages consulted, or "General MD3 compliance"}
- **Benchmark References:** {Reference to BENCHMARK.md visual references if used, or "N/A"}

---

## Checklist for Design Approval

- [ ] All screens have layouts with ASCII diagrams
- [ ] Platform differences documented where iOS and Android diverge
- [ ] All components have states and variants documented
- [ ] Color palette meets WCAG AA contrast ratios
- [ ] Typography scale is complete with platform-native units (pt / sp / dp)
- [ ] Navigation architecture defined with screen graph
- [ ] User flows cover happy path and error paths
- [ ] Gestures documented with edge cases
- [ ] VoiceOver accessibility requirements specified
- [ ] TalkBack accessibility requirements specified
- [ ] Touch targets meet platform minimums (44pt iOS, 48dp Android)
- [ ] Safe areas accounted for in screen layouts
- [ ] Adaptive layout defined for device size categories
- [ ] Interactive states documented (press, loading, error)
- [ ] Design approved by stakeholders
```
