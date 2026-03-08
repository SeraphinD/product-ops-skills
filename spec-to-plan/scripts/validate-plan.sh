#!/usr/bin/env bash
# validate-plan.sh — Validates that a PLAN.md has all required sections
# Usage: bash scripts/validate-plan.sh <path-to-plan>

set -euo pipefail

FILE="${1:?Usage: validate-plan.sh <path-to-PLAN.md>}"

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

echo "=== Validating PLAN.md: $FILE ==="
echo ""

echo "--- Required Sections ---"
check_section "^# Implementation Plan:" "Title (# Implementation Plan: ...)"

if grep -q "Generated from:" "$FILE"; then
  echo "  OK: Generated from reference"
else
  echo "FAIL: Missing 'Generated from:' reference"
  ERRORS=$((ERRORS + 1))
fi

check_section "^## Overview" "Overview"
check_section "^## Requirements Summary" "Requirements Summary"
check_section "^## Project Structure" "Project Structure"
check_section "^## Implementation Steps" "Implementation Steps"
check_section "^## Critical Files" "Critical Files"
check_section "^## Verification Checklist" "Verification Checklist"
check_section "^## Implementation Details" "Implementation Details"

echo ""
echo "--- Phase Structure ---"

# Count phases
PHASE_COUNT=$(grep -cE "^### Phase [0-9]+" "$FILE" 2>/dev/null || echo "0")
if [[ "$PHASE_COUNT" -eq 0 ]]; then
  echo "FAIL: No implementation phases found"
  ERRORS=$((ERRORS + 1))
else
  echo "  OK: $PHASE_COUNT phase(s) found"
fi

# Check for MoSCoW phase ordering
if grep -qE "^### Phase .* — MUST" "$FILE"; then
  echo "  OK: MUST phase present"
else
  echo "WARN: No phase explicitly labeled MUST"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for Testing phase
if grep -qiE "^### Phase .* Testing" "$FILE"; then
  echo "  OK: Testing phase present"
else
  echo "WARN: No dedicated Testing phase"
  WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "--- Content Quality ---"

# Check verification checklist items
CHECKLIST_COUNT=$(grep -cE '^\- \[ \]' "$FILE" 2>/dev/null || echo "0")
if [[ "$CHECKLIST_COUNT" -lt 2 ]]; then
  echo "WARN: Only $CHECKLIST_COUNT checklist items (expected at least 2)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $CHECKLIST_COUNT verification checklist items"
fi

# Check critical files
CF_COUNT=$(grep -cE '^\- `' "$FILE" 2>/dev/null || echo "0")
if [[ "$CF_COUNT" -lt 2 ]]; then
  echo "WARN: Only $CF_COUNT critical files listed (expected at least 2)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $CF_COUNT critical files listed"
fi

# Check for file tree
if grep -qE '[├└│]' "$FILE"; then
  echo "  OK: Project structure tree present"
else
  echo "WARN: No file tree characters found in Project Structure"
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
