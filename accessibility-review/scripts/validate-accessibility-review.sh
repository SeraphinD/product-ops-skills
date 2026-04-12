#!/usr/bin/env bash
# validate-accessibility-review.sh — Validates that an ACCESSIBILITY-REVIEW.md has all required sections
# Usage: bash scripts/validate-accessibility-review.sh <path-to-ACCESSIBILITY-REVIEW.md>

set -euo pipefail

FILE="${1:?Usage: validate-accessibility-review.sh <path-to-ACCESSIBILITY-REVIEW.md>}"

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

check_warn() {
  local pattern="$1"
  local label="$2"
  if ! grep -qiE "$pattern" "$FILE"; then
    echo "WARN: Missing — $label"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "  OK: $label"
  fi
}

echo "=== Validating ACCESSIBILITY-REVIEW.md: $FILE ==="
echo ""

# --- Header metadata ---
echo "--- Header ---"
check_section "^# Accessibility Review:" "Title (# Accessibility Review: ...)"
check_section "Reviewed artifact:" "Reviewed artifact reference"
check_section "Review mode:" "Review mode"
check_section "Platform:" "Platform declaration"
check_warn "Standards:" "Standards declaration"
check_warn "Date:" "Date"

# --- Detect review mode ---
MODE="unknown"
if grep -qiE "Review mode:.*Triage" "$FILE"; then
  MODE="triage"
elif grep -qiE "Review mode:.*Deep" "$FILE"; then
  MODE="deep"
elif grep -qiE "Review mode:.*Verify" "$FILE"; then
  MODE="verify"
fi
echo ""
echo "Detected review mode: $MODE"

# --- Mode-specific sections ---
echo ""
echo "--- Content Sections ---"

if [[ "$MODE" == "deep" ]]; then
  check_section "^## Accessibility Audit" "Accessibility Audit"
  check_section "^## Compliance Acceptance Criteria\|^## Summary" "Compliance ACs or Summary"
  check_section "^## Summary" "Summary"
  # Check for at least one platform-specific section
  if grep -qiE "^### Web Findings|^### iOS Findings|^### Android Findings|^### Cross-Platform Findings|^## Color Contrast" "$FILE"; then
    echo "  OK: Platform-specific findings present"
  else
    echo "WARN: No platform-specific findings section found"
    WARNINGS=$((WARNINGS + 1))
  fi
elif [[ "$MODE" == "triage" ]]; then
  check_section "^## UI Detection" "UI Detection"
  check_section "^## Initial Assessment" "Initial Assessment"
  check_section "^## Recommendations for SPEC" "Recommendations for SPEC"
  check_section "^## Summary" "Summary"
elif [[ "$MODE" == "verify" ]]; then
  check_section "^## Testing Coverage" "Testing Coverage"
  check_section "^## Coverage Check" "Coverage Check"
  check_section "^## Gap Report" "Gap Report"
  check_section "^## Summary" "Summary"
  check_warn "Prior review:" "Prior review reference"
else
  echo "WARN: Could not detect review mode — checking for Summary only"
  WARNINGS=$((WARNINGS + 1))
  check_section "^## Summary" "Summary"
fi

# --- Content quality ---
echo ""
echo "--- Content Quality ---"
TABLE_ROWS=$(grep -cE "^\|.*\|.*\|" "$FILE" 2>/dev/null || echo "0")
if [[ "$TABLE_ROWS" -lt 3 ]]; then
  echo "WARN: Few table rows found ($TABLE_ROWS) — review may lack structured data"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $TABLE_ROWS table rows found"
fi

# --- Standard references ---
WCAG_COUNT=$(grep -coE "WCAG [0-9]\.[0-9]\.[0-9]\|[0-9]\.[0-9]\.[0-9]" "$FILE" 2>/dev/null || echo "0")
HIG_COUNT=$(grep -ciE "HIG|VoiceOver|accessibilityLabel|accessibilityTraits" "$FILE" 2>/dev/null || echo "0")
MATERIAL_COUNT=$(grep -ciE "TalkBack|contentDescription|Material" "$FILE" 2>/dev/null || echo "0")

if [[ "$MODE" == "deep" ]]; then
  TOTAL_REFS=$((WCAG_COUNT + HIG_COUNT + MATERIAL_COUNT))
  if [[ "$TOTAL_REFS" -lt 3 ]]; then
    echo "WARN: Only $TOTAL_REFS standard references found in deep mode (expected 3+)"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "  OK: $TOTAL_REFS standard reference(s) (WCAG: $WCAG_COUNT, HIG/VoiceOver: $HIG_COUNT, Material/TalkBack: $MATERIAL_COUNT)"
  fi
fi

# --- Given/When/Then in deep mode ---
if [[ "$MODE" == "deep" ]]; then
  GWT_COUNT=$(grep -cE "\*\*GIVEN\*\*|\*\*WHEN\*\*|\*\*THEN\*\*" "$FILE" 2>/dev/null || echo "0")
  if [[ "$GWT_COUNT" -lt 3 ]]; then
    echo "WARN: Compliance ACs may be missing Given/When/Then format (found $GWT_COUNT markers)"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "  OK: Given/When/Then markers found ($GWT_COUNT)"
  fi
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
