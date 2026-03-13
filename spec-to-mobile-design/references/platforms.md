# Mobile Platform Reference

Detailed patterns loaded on demand by `spec-to-mobile-design`. Reference this file during Steps 7, 11, 15, 17, and 18.

---

## Design System Detection Patterns (Step 7)

### Cross-platform (React Native / Expo)
- `**/theme.ts`, `**/theme.js`, `**/tokens.ts` — exported theme objects with colors, fonts, spacing
- `**/styles/**`, `**/theme/**`, `**/design-system/**` — directories suggesting a design system
- `package.json` → look for `react-native`, `expo`, `react-native-paper`, `@shopify/restyle`, `nativewind`, `tamagui`, `gluestack-ui`, `react-native-elements`

### Flutter
- `**/theme.dart`, `**/app_theme.dart`, `**/colors.dart`, `**/typography.dart` — Dart theme files
- `pubspec.yaml` → look for `flutter`, `material_design_icons_flutter`, `google_fonts`
- `ThemeData(` patterns in `lib/` files

### iOS (Swift)
- `**/Theme.swift`, `**/Colors.swift`, `**/Typography.swift`, `**/DesignTokens.swift`
- `Assets.xcassets/` → color sets and image sets
- `*.xcodeproj` or `Package.swift` → confirms iOS project

### Android (Kotlin / Jetpack Compose)
- `**/ui/theme/`, `**/Theme.kt`, `**/Color.kt`, `**/Type.kt` — Compose theme files
- `res/values/colors.xml`, `res/values/themes.xml`, `res/values/styles.xml` — XML resources
- `build.gradle*` → look for `com.google.android.material`, `androidx.compose`

### What to extract when found
- Color palette: names, hex values, semantic roles, platform token names
- Typography: font families, sizes in pt/dp/sp, weights
- Spacing: base unit, scale values in pt/dp
- Component patterns: naming convention, file structure

---

## Component Vocabulary Mapping (Step 11)

Use native component names, not web terminology:

| Web concept | iOS equivalent | Android equivalent |
|---|---|---|
| Modal / Dialog | Sheet / Alert | Bottom Sheet / Dialog |
| Dropdown / Select | Picker / Menu | Exposed Dropdown Menu |
| Text input | TextField | OutlinedTextField / FilledTextField |
| Checkbox | Toggle (often) | Checkbox |
| Navigation bar | NavigationBar (top) | TopAppBar |
| Tab bar | TabBar (bottom) | NavigationBar (bottom) |
| Toast / Snackbar | (no native — use banner or alert) | Snackbar |
| Card | (custom — rounded rectangle) | Card (Material 3) |
| Floating action button | (not idiomatic iOS) | FloatingActionButton |

When a component differs significantly between platforms, document both variants. When functionally identical, document once and note "same on both platforms."

---

## Accessibility Checklists (Step 17)

### iOS (VoiceOver)
- [ ] All interactive elements have `accessibilityLabel` set
- [ ] Custom components implement `UIAccessibilityElement` or use `.accessibilityElement()` in SwiftUI
- [ ] Logical focus order (`accessibilityElements` array or SwiftUI `.accessibilitySortPriority()`)
- [ ] Dynamic Type support — text scales with user's preferred content size
- [ ] `accessibilityTraits` correctly set (button, header, selected, adjustable, etc.)
- [ ] Custom actions via `accessibilityCustomActions` where swipe gestures need non-gestural alternatives

### Android (TalkBack)
- [ ] All interactive elements have `contentDescription` set
- [ ] `importantForAccessibility` correctly configured
- [ ] Logical focus order via `accessibilityTraversalBefore/After` or Compose semantics
- [ ] Text scales with system font size preferences
- [ ] Correct `Role` semantics in Jetpack Compose (Button, Checkbox, Tab, etc.)
- [ ] Touch target sizes minimum 48×48dp (Material Design guideline)

### Universal
- [ ] WCAG 2.1 Level AA compliance target
- [ ] Color contrast minimum 4.5:1 for normal text, 3:1 for large text
- [ ] No information conveyed by color alone
- [ ] Error messages associated with their inputs
- [ ] Loading states announced to screen readers
- [ ] Reduced motion respected on both platforms (`UIAccessibility.isReduceMotionEnabled` / `Settings.Global.ANIMATOR_DURATION_SCALE`)

Add SPEC-specific accessibility items derived from the functional scope and acceptance criteria. If BENCHMARK.md mentioned accessibility standards, incorporate them.

---

## Haptic Feedback APIs (Step 15)

### iOS
- `UIImpactFeedbackGenerator(.light / .medium / .heavy)` — physical impact
- `UINotificationFeedbackGenerator(.success / .warning / .error)` — outcome feedback
- `UISelectionFeedbackGenerator()` — selection change

### Android
- `HapticFeedbackConstants.CONFIRM` / `REJECT` / `CONTEXT_CLICK` (API 30+)
- `Vibrator.vibrate(VibrationEffect.createOneShot(...))` for custom patterns
- Keep haptics minimal unless the spec explicitly calls for rich patterns

---

## Dark Mode Token Mapping (Step 18)

### iOS — Semantic Colors
Use system semantic colors that adapt automatically:
`systemBackground`, `secondarySystemBackground`, `label`, `secondaryLabel`, `systemBlue`, `systemRed`, etc.

For custom tokens: define light/dark variants in `Assets.xcassets` color sets or via `UIColor(dynamicProvider:)`.

### Android — Material 3 Dynamic Color
Use Material 3 role-based tokens: `surface`, `onSurface`, `surfaceVariant`, `primary`, `onPrimary`, `secondary`, `error`, `onError`, etc.

Dynamic Color (Android 12+) automatically generates a palette from the system wallpaper — opt in via `DynamicColors.applyToActivityIfAvailable(this)`.

---

## Adaptive Layout APIs (Step 18)

### iOS Size Classes
- **Compact width** (iPhone portrait, iPhone landscape on small devices): stack layouts, single-column
- **Regular width** (iPad, iPhone Plus landscape): side-by-side layouts, master-detail
- Check via `@Environment(\.horizontalSizeClass)` in SwiftUI or `traitCollection.horizontalSizeClass` in UIKit

### Android Window Size Classes
- **Compact** (< 600dp): single-pane, bottom navigation
- **Medium** (600–840dp): two-pane optional, navigation rail
- **Expanded** (> 840dp): persistent navigation drawer, multi-pane
- Check via `WindowSizeClass` from `androidx.window.layout`
