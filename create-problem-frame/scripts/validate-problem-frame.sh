#!/usr/bin/env bash
# validate-problem-frame.sh — Validates that a PROBLEM-FRAME.md has all required sections and meets constraints
# Usage: bash scripts/validate-problem-frame.sh <path-to-PROBLEM-FRAME.md>

set -euo pipefail

FILE="${1:?Usage: validate-problem-frame.sh <path-to-PROBLEM-FRAME.md>}"

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
  local count
  count=$(awk "/$start_pattern/{found=1; next} /^#/{if(found) exit} found && /^- /" "$FILE" | wc -l | tr -d ' ')
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

echo "=== Validating PROBLEM-FRAME.md: $FILE ==="
echo ""

# Check required sections
echo "--- Required Sections ---"
check_section "^# Problem Frame:" "Title (# Problem Frame: ...)"
check_section "^## Situation Context" "Situation Context"
check_section "^## Problem Statement" "Problem Statement"
check_section "^### Stress Test" "Stress Test"
check_section "^## Root Cause Analysis" "Root Cause Analysis"
check_section "^### Why Chain" "Why Chain"
check_section "^### Root Cause" "Root Cause"
check_section "^## Constraints & Boundaries" "Constraints & Boundaries"
check_section "^### Hard Constraints" "Hard Constraints"
check_section "^### Problem Boundaries" "Problem Boundaries"
check_section "^## Success Definition" "Success Definition"
check_section "^### Target State" "Target State"
check_section "^### Measurable Signals" "Measurable Signals"
check_section "^### What Success is NOT" "What Success is NOT"
check_section "^## Alternative Framings" "Alternative Framings"
check_section "^## Chosen Frame" "Chosen Frame"
check_section "^### Selected Problem Statement" "Selected Problem Statement"
check_section "^### Why This Frame" "Why This Frame"

echo ""
echo "--- Item Counts ---"
count_items "^### Hard Constraints" 1 10 "Hard Constraints"
count_items "^### Problem Boundaries" 1 10 "Problem Boundaries"
count_items "^### Measurable Signals" 3 5 "Measurable Signals"

echo ""
echo "--- Content Quality ---"

# Check for Why Chain depth (at least 2 levels)
WHY_COUNT=$(grep -c '^\*\*Why [0-9]' "$FILE" 2>/dev/null || echo "0")
if [[ "$WHY_COUNT" -lt 2 ]]; then
  echo "WARN: Why Chain has only $WHY_COUNT level(s) (minimum: 2)"
  WARNINGS=$((WARNINGS + 1))
elif [[ "$WHY_COUNT" -gt 5 ]]; then
  echo "WARN: Why Chain has $WHY_COUNT levels (maximum: 5)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: Why Chain — $WHY_COUNT levels"
fi

# Check for alternative framings (at least 2)
FRAMING_COUNT=$(grep -c '^### Framing [A-Z]' "$FILE" 2>/dev/null || echo "0")
if [[ "$FRAMING_COUNT" -lt 2 ]]; then
  echo "WARN: Only $FRAMING_COUNT alternative framing(s) (minimum: 2)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $FRAMING_COUNT alternative framings"
fi

# Check for placeholder text
if grep -qE '\[.*\]' "$FILE" 2>/dev/null; then
  PLACEHOLDER_COUNT=$(grep -cE '\[Who\]|\[what\]|\[why\]|\[consequence\]|\[Working Title\]' "$FILE" 2>/dev/null || echo "0")
  if [[ "$PLACEHOLDER_COUNT" -gt 0 ]]; then
    echo "WARN: $PLACEHOLDER_COUNT possible placeholder(s) found (template text not replaced)"
    WARNINGS=$((WARNINGS + 1))
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
