#!/usr/bin/env bash
# validate-mobile-design.sh — Validates that a mobile DESIGN.md has all required sections
# Usage: bash scripts/validate-mobile-design.sh <path-to-design>

set -euo pipefail

FILE="${1:?Usage: validate-mobile-design.sh <path-to-DESIGN.md>}"

if [[ ! -f "$FILE" ]]; then
  echo "ERROR: File not found: $FILE"
  exit 1
fi

ERRORS=0
WARNINGS=0

check_section() {
  local pattern="$1"
  local label="$2"
  if ! grep -qiE "$pattern" "$FILE"; then
    echo "FAIL: Missing section — $label"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK: $label"
  fi
}

echo "=== Validating Mobile DESIGN.md: $FILE ==="
echo ""

# --- Required Sections ---
echo "--- Required Sections ---"
check_section "^# Mobile Design:" "Title (# Mobile Design: ...)"

if grep -q "Generated from:" "$FILE"; then
  echo "  OK: Generated from reference"
else
  echo "FAIL: Missing 'Generated from:' reference"
  ERRORS=$((ERRORS + 1))
fi

if grep -qiE "^> Platforms:" "$FILE"; then
  echo "  OK: Platforms declared"
else
  echo "WARN: Missing 'Platforms:' declaration"
  WARNINGS=$((WARNINGS + 1))
fi

if grep -qiE "^> Framework:" "$FILE"; then
  echo "  OK: Framework declared"
else
  echo "WARN: Missing 'Framework:' declaration"
  WARNINGS=$((WARNINGS + 1))
fi

check_section "^## Design Overview" "Design Overview"
check_section "^## Design Goals" "Design Goals"
check_section "^## Platform Strategy" "Platform Strategy"
check_section "^## Design System" "Design System"
check_section "^### Color Palette" "Color Palette"
check_section "^### Typography" "Typography"
check_section "^### Spacing" "Spacing & Safe Areas"
check_section "^## Native Components" "Native Components"
check_section "^## Screen Layouts" "Screen Layouts"
check_section "^## Navigation Architecture" "Navigation Architecture"
check_section "^## User Flows" "User Flows"
check_section "^## Gestures" "Gestures & Haptics"
check_section "^## Interactions" "Interactions & Animations"
check_section "^## Accessibility" "Accessibility Requirements"
check_section "^## Adaptive Layout" "Adaptive Layout"

echo ""
echo "--- Content Quality ---"

# Check for hex color codes
HEX_COUNT=$(grep -coE '#[0-9a-fA-F]{6}' "$FILE" 2>/dev/null || echo "0")
if [[ "$HEX_COUNT" -lt 3 ]]; then
  echo "WARN: Only $HEX_COUNT hex color codes found (expected at least 5)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $HEX_COUNT hex color codes found"
fi

# Check for contrast ratios
if grep -q "4.5:1\|3:1" "$FILE"; then
  echo "  OK: Contrast ratios mentioned"
else
  echo "WARN: No WCAG contrast ratios (4.5:1 or 3:1) found"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for platform-native units (pt for iOS, sp/dp for Android)
if grep -qE '[0-9]+pt' "$FILE"; then
  echo "  OK: iOS units (pt) found"
else
  echo "WARN: No iOS point units (pt) found in typography or spacing"
  WARNINGS=$((WARNINGS + 1))
fi

if grep -qE '[0-9]+(sp|dp)' "$FILE"; then
  echo "  OK: Android units (sp/dp) found"
else
  echo "WARN: No Android units (sp/dp) found in typography or spacing"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for ASCII diagrams (box-drawing characters)
if grep -qE '[│─┌┐└┘├┤┬┴┼]' "$FILE"; then
  echo "  OK: ASCII wireframes present"
else
  echo "WARN: No ASCII box-drawing wireframes found"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for Source Story references
SS_COUNT=$(grep -c "Source Story:" "$FILE" 2>/dev/null || echo "0")
if [[ "$SS_COUNT" -eq 0 ]]; then
  echo "WARN: No 'Source Story:' references — components should trace to SPEC user stories"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $SS_COUNT Source Story references"
fi

# Check for WCAG reference
if grep -q "WCAG" "$FILE"; then
  echo "  OK: WCAG compliance referenced"
else
  echo "WARN: No WCAG reference found"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for touch target sizes
if grep -qE "44x44|44×44|48x48|48×48" "$FILE"; then
  echo "  OK: Touch target sizes specified"
else
  echo "WARN: No touch target sizes (44x44pt iOS / 48x48dp Android) found"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for safe area mentions
if grep -qi "safe area\|safe.area\|safearea" "$FILE"; then
  echo "  OK: Safe areas addressed"
else
  echo "WARN: No safe area mentions found"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for VoiceOver / TalkBack accessibility
if grep -qi "VoiceOver" "$FILE"; then
  echo "  OK: VoiceOver (iOS) accessibility addressed"
else
  echo "WARN: No VoiceOver (iOS) accessibility mentions"
  WARNINGS=$((WARNINGS + 1))
fi

if grep -qi "TalkBack" "$FILE"; then
  echo "  OK: TalkBack (Android) accessibility addressed"
else
  echo "WARN: No TalkBack (Android) accessibility mentions"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for haptics
if grep -qiE "haptic|UIImpactFeedbackGenerator|HapticFeedbackConstants" "$FILE"; then
  echo "  OK: Haptic feedback documented"
else
  echo "WARN: No haptic feedback documentation found"
  WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "=== Results ==="
if [[ "$ERRORS" -eq 0 && "$WARNINGS" -eq 0 ]]; then
  echo "All checks passed."
  exit 0
elif [[ "$ERRORS" -eq 0 ]]; then
  echo "$WARNINGS warning(s), 0 errors."
  exit 0
else
  echo "$ERRORS error(s), $WARNINGS warning(s)."
  exit 1
fi
