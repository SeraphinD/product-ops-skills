#!/usr/bin/env bash
# validate-gdpr-review.sh — Validates that a GDPR-REVIEW.md has all required sections and structure
# Usage: bash scripts/validate-gdpr-review.sh <path-to-GDPR-REVIEW.md>

set -euo pipefail

FILE="${1:?Usage: validate-gdpr-review.sh <path-to-GDPR-REVIEW.md>}"

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

echo "=== Validating GDPR-REVIEW.md: $FILE ==="
echo ""

# --- Header metadata ---
echo "--- Header ---"
check_section "^# GDPR Review:" "Title (# GDPR Review: ...)"
check_section "Reviewed artifact:" "Reviewed artifact reference"
check_section "Review mode:" "Review mode"
check_warn "Date:" "Date"
check_section "Disclaimer" "Legal disclaimer"

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
  check_section "^## Personal Data Inventory" "Personal Data Inventory"
  check_section "^## Legal Basis Assessment" "Legal Basis Assessment"
  check_section "^## Data Subject Rights Coverage" "Data Subject Rights Coverage"
  check_section "^## Privacy by Design Assessment" "Privacy by Design Assessment"
  check_section "^## DPIA Assessment" "DPIA Assessment"
  check_warn "^## Consent Assessment" "Consent Assessment (if consent is a legal basis)"
  check_section "^## Compliance Acceptance Criteria" "Compliance Acceptance Criteria"
  check_section "^## Summary" "Summary"
elif [[ "$MODE" == "triage" ]]; then
  check_section "^## Personal Data Detection" "Personal Data Detection"
  check_section "^## Initial Risk Assessment" "Initial Risk Assessment"
  check_section "^## Recommendations for SPEC" "Recommendations for SPEC"
  check_section "^## Summary" "Summary"
elif [[ "$MODE" == "verify" ]]; then
  check_section "^## Coverage Check" "Coverage Check"
  check_section "^## Gap Report" "Gap Report"
  check_section "^## Summary" "Summary"
  check_warn "Prior review:" "Prior review reference"
else
  echo "WARN: Could not detect review mode — checking for Summary only"
  WARNINGS=$((WARNINGS + 1))
  check_section "^## Summary" "Summary"
fi

# --- Table presence ---
echo ""
echo "--- Content Quality ---"
TABLE_ROWS=$(grep -cE "^\|.*\|.*\|" "$FILE" 2>/dev/null || echo "0")
if [[ "$TABLE_ROWS" -lt 3 ]]; then
  echo "WARN: Few table rows found ($TABLE_ROWS) — review may lack structured data"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $TABLE_ROWS table rows found"
fi

# --- GDPR article references ---
ART_COUNT=$(grep -coE "Art\. [0-9]+" "$FILE" 2>/dev/null || echo "0")
if [[ "$MODE" == "deep" && "$ART_COUNT" -lt 3 ]]; then
  echo "WARN: Only $ART_COUNT GDPR article references found in deep mode (expected 3+)"
  WARNINGS=$((WARNINGS + 1))
elif [[ "$ART_COUNT" -gt 0 ]]; then
  echo "  OK: $ART_COUNT GDPR article reference(s)"
else
  echo "WARN: No GDPR article references found"
  WARNINGS=$((WARNINGS + 1))
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
