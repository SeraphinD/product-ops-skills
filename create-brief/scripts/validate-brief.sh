#!/usr/bin/env bash
# validate-brief.sh — Validates that a BRIEF.md has all required sections and meets constraints
# Usage: bash scripts/validate-brief.sh <path-to-brief>

set -euo pipefail

FILE="${1:?Usage: validate-brief.sh <path-to-BRIEF.md>}"

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

count_items() {
  local start_pattern="$1"
  local min="$2"
  local max="$3"
  local label="$4"
  # Count bullet points between the section header and the next ## header
  local count
  count=$(awk "/$start_pattern/{found=1; next} /^## /{if(found) exit} found && /^- /" "$FILE" | wc -l | tr -d ' ')
  if [[ "$count" -lt "$min" ]]; then
    echo "WARN: $label has $count items (minimum: $min)"
    WARNINGS=$((WARNINGS + 1))
  elif [[ "$count" -gt "$max" ]]; then
    echo "WARN: $label has $count items (maximum: $max)"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "  OK: $label — $count items"
  fi
}

echo "=== Validating BRIEF.md: $FILE ==="
echo ""

# Check required sections
echo "--- Required Sections ---"
check_section "^# Project Brief:" "Title (# Project Brief: ...)"
check_section "^## Executive Summary" "Executive Summary"
check_section "^## Problem Statement" "Problem Statement"
check_section "^## Solution" "Solution"
check_section "^## Key Objectives" "Key Objectives"
check_section "^## Scope" "Scope"
check_section "^### In Scope" "In Scope"
check_section "^### Out of Scope" "Out of Scope"
check_section "^## Success Criteria" "Success Criteria"

echo ""
echo "--- Item Counts ---"
count_items "^## Key Objectives" 3 7 "Key Objectives"
count_items "^### In Scope" 5 10 "In Scope items"
count_items "^### Out of Scope" 3 8 "Out of Scope items"
count_items "^## Success Criteria" 3 8 "Success Criteria"

echo ""
echo "--- Content Quality ---"

# Check for placeholder text
if grep -qE '\[.*\]' "$FILE" | grep -v '^\[x\]' | grep -v '^\[' 2>/dev/null; then
  echo "WARN: Possible placeholder text found (brackets [])"
  WARNINGS=$((WARNINGS + 1))
fi

# Check success criteria are checkboxes
SC_COUNT=$(grep -c '^\- \[x\]' "$FILE" 2>/dev/null || echo "0")
if [[ "$SC_COUNT" -eq 0 ]]; then
  echo "WARN: No success criteria use [x] checkbox format"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $SC_COUNT success criteria with [x] format"
fi

# Check objectives use ✓ prefix
OBJ_CHECK=$(grep -c '✓' "$FILE" 2>/dev/null || echo "0")
if [[ "$OBJ_CHECK" -eq 0 ]]; then
  echo "WARN: No objectives use ✓ prefix"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $OBJ_CHECK objectives with ✓ prefix"
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
