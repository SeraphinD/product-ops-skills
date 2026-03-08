#!/usr/bin/env bash
# validate-design.sh — Validates that a DESIGN.md has all required sections
# Usage: bash scripts/validate-design.sh <path-to-design>

set -euo pipefail

FILE="${1:?Usage: validate-design.sh <path-to-DESIGN.md>}"

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

echo "=== Validating DESIGN.md: $FILE ==="
echo ""

# Check header
echo "--- Required Sections ---"
check_section "^# Design:" "Title (# Design: ...)"

if grep -q "Generated from:" "$FILE"; then
  echo "  OK: Generated from reference"
else
  echo "FAIL: Missing 'Generated from:' reference"
  ERRORS=$((ERRORS + 1))
fi

check_section "^## Design Overview" "Design Overview"
check_section "^## Design Goals" "Design Goals"
check_section "^## Design System" "Design System"
check_section "^### Color Palette" "Color Palette"
check_section "^### Typography" "Typography"
check_section "^### Spacing" "Spacing & Layout"
check_section "^## Components" "Components"
check_section "^## Page Layouts" "Page Layouts"
check_section "^## User Flows" "User Flows"
check_section "^## Interactions" "Interactions & Animations"
check_section "^## Accessibility" "Accessibility Requirements"
check_section "^## Responsive" "Responsive Design Details"

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

# Check for WCAG checklist
if grep -q "WCAG" "$FILE"; then
  echo "  OK: WCAG compliance referenced"
else
  echo "WARN: No WCAG reference found"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for breakpoints
if grep -qE "640px|768px|1024px" "$FILE"; then
  echo "  OK: Responsive breakpoints defined"
else
  echo "WARN: No standard breakpoints found"
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
