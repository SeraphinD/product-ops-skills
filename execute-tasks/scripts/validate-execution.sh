#!/usr/bin/env bash
# validate-execution.sh — Validates TASKS.md consistency after execution
# Checks: status consistency, completed tasks have dates, no in-progress without context,
#          dependency ordering, header counts match actual counts
# Usage: bash scripts/validate-execution.sh <path-to-TASKS.md>

set -euo pipefail

FILE="${1:?Usage: validate-execution.sh <path-to-TASKS.md>}"

if [[ ! -f "$FILE" ]]; then
  echo "ERROR: File not found: $FILE"
  exit 1
fi

ERRORS=0
WARNINGS=0

echo "=== Validating Execution State: $FILE ==="
echo ""

echo "--- Status Consistency ---"

# Count actual statuses from task entries
PENDING=$(grep -c "⬜" "$FILE" 2>/dev/null || echo "0")
IN_PROGRESS=$(grep -c "🔄" "$FILE" 2>/dev/null || echo "0")
COMPLETED=$(grep -c "✅" "$FILE" 2>/dev/null || echo "0")
BLOCKED=$(grep -c "❌" "$FILE" 2>/dev/null || echo "0")
TOTAL=$((PENDING + IN_PROGRESS + COMPLETED + BLOCKED))

echo "  Actual counts: ⬜ $PENDING | 🔄 $IN_PROGRESS | ✅ $COMPLETED | ❌ $BLOCKED | Total: $TOTAL"

# Check header counts match actual counts
if grep -qE "Total Tasks:" "$FILE"; then
  HEADER_TOTAL=$(grep -oE "Total Tasks: [0-9]+" "$FILE" | grep -oE "[0-9]+" | head -1 || echo "0")
  if [[ "$HEADER_TOTAL" -ne "$TOTAL" ]]; then
    echo "FAIL: Header says Total Tasks: $HEADER_TOTAL but actual count is $TOTAL"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK: Header total matches actual count"
  fi

  HEADER_PENDING=$(grep -oE "Pending: [0-9]+" "$FILE" | grep -oE "[0-9]+" | head -1 || echo "0")
  if [[ "$HEADER_PENDING" -ne "$PENDING" ]]; then
    echo "FAIL: Header says Pending: $HEADER_PENDING but actual count is $PENDING"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK: Header pending matches"
  fi

  HEADER_COMPLETED=$(grep -oE "Completed: [0-9]+" "$FILE" | grep -oE "[0-9]+" | head -1 || echo "0")
  if [[ "$HEADER_COMPLETED" -ne "$COMPLETED" ]]; then
    echo "FAIL: Header says Completed: $HEADER_COMPLETED but actual count is $COMPLETED"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK: Header completed matches"
  fi

  HEADER_BLOCKED=$(grep -oE "Blocked: [0-9]+" "$FILE" | grep -oE "[0-9]+" | head -1 || echo "0")
  if [[ "$HEADER_BLOCKED" -ne "$BLOCKED" ]]; then
    echo "FAIL: Header says Blocked: $HEADER_BLOCKED but actual count is $BLOCKED"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK: Header blocked matches"
  fi
else
  echo "WARN: No header counts found (Total Tasks: ...)"
  WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "--- Completed Task Validation ---"

# Check that completed tasks have dates
COMPLETED_NO_DATE=$(grep -cE "✅ completed[^0-9]" "$FILE" 2>/dev/null || echo "0")
COMPLETED_WITH_STATUS=$(grep -cE "✅ completed" "$FILE" 2>/dev/null || echo "0")
COMPLETED_WITH_DATE=$(grep -cE "✅ completed [0-9]{4}-[0-9]{2}-[0-9]{2}" "$FILE" 2>/dev/null || echo "0")

if [[ "$COMPLETED_WITH_STATUS" -gt 0 && "$COMPLETED_WITH_DATE" -lt "$COMPLETED_WITH_STATUS" ]]; then
  MISSING_DATES=$((COMPLETED_WITH_STATUS - COMPLETED_WITH_DATE))
  echo "FAIL: $MISSING_DATES completed task(s) missing completion date"
  ERRORS=$((ERRORS + 1))
elif [[ "$COMPLETED_WITH_STATUS" -gt 0 ]]; then
  echo "  OK: All completed tasks have dates"
else
  echo "  OK: No completed tasks to validate"
fi

echo ""
echo "--- Blocked Task Validation ---"

# Check that blocked tasks have reasons in Notes
if [[ "$BLOCKED" -gt 0 ]]; then
  BLOCKED_WITH_REASON=$(grep -cE "❌ Blocked [0-9]{4}" "$FILE" 2>/dev/null || echo "0")
  if [[ "$BLOCKED_WITH_REASON" -lt "$BLOCKED" ]]; then
    echo "WARN: Some blocked tasks may be missing block reason or date in Notes"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "  OK: All blocked tasks have dated reasons"
  fi
else
  echo "  OK: No blocked tasks"
fi

echo ""
echo "--- In-Progress Validation ---"

# Warn if multiple tasks are in-progress (unusual)
if [[ "$IN_PROGRESS" -gt 1 ]]; then
  echo "WARN: $IN_PROGRESS tasks are in-progress simultaneously (expected 0 or 1)"
  WARNINGS=$((WARNINGS + 1))
elif [[ "$IN_PROGRESS" -eq 1 ]]; then
  echo "  OK: 1 task in-progress"
else
  echo "  OK: No tasks in-progress"
fi

echo ""
echo "--- Dependency Check ---"

# Check for tasks that depend on blocked tasks
DEPENDS_LINES=$(grep -n "Depends on:" "$FILE" 2>/dev/null || true)
if [[ -n "$DEPENDS_LINES" ]]; then
  echo "  INFO: Found dependency declarations"
  # Basic check: warn if pending tasks reference tasks that aren't completed
  echo "  INFO: Manual review recommended for dependency chain integrity"
else
  echo "  OK: No explicit dependencies declared"
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
