#!/usr/bin/env bash
# validate-tasks.sh — Validates that a TASKS.md has all required sections and structure
# Usage: bash scripts/validate-tasks.sh <path-to-tasks>

set -euo pipefail

FILE="${1:?Usage: validate-tasks.sh <path-to-TASKS.md>}"

if [[ ! -f "$FILE" ]]; then
  echo "ERROR: File not found: $FILE"
  exit 1
fi

ERRORS=0
WARNINGS=0

echo "=== Validating TASKS.md: $FILE ==="
echo ""

echo "--- Structure ---"

# Check title
if grep -qE "^# TASKS" "$FILE"; then
  echo "  OK: Title present"
else
  echo "FAIL: Missing title (# TASKS.md)"
  ERRORS=$((ERRORS + 1))
fi

# Check Generated from reference
if grep -q "Generated from:" "$FILE"; then
  echo "  OK: Generated from reference"
else
  echo "FAIL: Missing 'Generated from:' reference"
  ERRORS=$((ERRORS + 1))
fi

# Check status counts header
if grep -qE "Total Tasks:" "$FILE"; then
  echo "  OK: Task counts header present"
else
  echo "WARN: Missing task counts header (Total Tasks: ...)"
  WARNINGS=$((WARNINGS + 1))
fi

# Check Summary table
if grep -qE "^## Summary" "$FILE"; then
  echo "  OK: Summary section present"
else
  echo "FAIL: Missing Summary section"
  ERRORS=$((ERRORS + 1))
fi

echo ""
echo "--- Task Quality ---"

# Count phases
PHASE_COUNT=$(grep -cE "^## Phase [0-9]+" "$FILE" 2>/dev/null || echo "0")
if [[ "$PHASE_COUNT" -eq 0 ]]; then
  echo "FAIL: No phases found"
  ERRORS=$((ERRORS + 1))
else
  echo "  OK: $PHASE_COUNT phase(s)"
fi

# Count tasks (### headers within phases)
TASK_COUNT=$(grep -cE "^### " "$FILE" 2>/dev/null || echo "0")
echo "  OK: $TASK_COUNT task(s) found"

# Check that all tasks have required fields
STATUS_COUNT=$(grep -c "^\- \*\*Status:\*\*" "$FILE" 2>/dev/null || echo "0")
DESC_COUNT=$(grep -c "^\- \*\*Description:\*\*" "$FILE" 2>/dev/null || echo "0")
REF_COUNT=$(grep -c "^\- \*\*PLAN Reference:\*\*" "$FILE" 2>/dev/null || echo "0")
SKILL_COUNT=$(grep -c "^\- \*\*Skill/Agent:\*\*" "$FILE" 2>/dev/null || echo "0")

if [[ "$STATUS_COUNT" -lt "$TASK_COUNT" ]]; then
  echo "WARN: Only $STATUS_COUNT Status fields for $TASK_COUNT tasks"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: All tasks have Status field"
fi

if [[ "$DESC_COUNT" -lt "$TASK_COUNT" ]]; then
  echo "WARN: Only $DESC_COUNT Description fields for $TASK_COUNT tasks"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: All tasks have Description field"
fi

if [[ "$REF_COUNT" -lt "$TASK_COUNT" ]]; then
  echo "WARN: Only $REF_COUNT PLAN Reference fields for $TASK_COUNT tasks"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: All tasks have PLAN Reference field"
fi

if [[ "$SKILL_COUNT" -lt "$TASK_COUNT" ]]; then
  echo "WARN: Only $SKILL_COUNT Skill/Agent fields for $TASK_COUNT tasks"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: All tasks have Skill/Agent assignment"
fi

# Check for valid status values
VALID_STATUS=$(grep -cE "(⬜|🔄|✅|❌)" "$FILE" 2>/dev/null || echo "0")
if [[ "$VALID_STATUS" -lt "$TASK_COUNT" ]]; then
  echo "WARN: Some tasks may have non-standard status values"
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
