#!/usr/bin/env bash
# validate-retro.sh — Validates that a RETRO.md has all required sections and structure
# Usage: bash scripts/validate-retro.sh <path-to-retro>

set -euo pipefail

FILE="${1:?Usage: validate-retro.sh <path-to-RETRO.md>}"

if [[ ! -f "$FILE" ]]; then
  echo "ERROR: File not found: $FILE"
  exit 1
fi

ERRORS=0
WARNINGS=0

echo "=== Validating RETRO.md: $FILE ==="
echo ""

echo "--- Header ---"

# Check title
if grep -qE "^# Feature Retrospective:" "$FILE"; then
  echo "  OK: Title present"
else
  echo "FAIL: Missing title (# Feature Retrospective: {name})"
  ERRORS=$((ERRORS + 1))
fi

# Check Generated from reference
if grep -q "Generated from:" "$FILE"; then
  echo "  OK: Generated from reference"
else
  echo "FAIL: Missing 'Generated from:' reference"
  ERRORS=$((ERRORS + 1))
fi

# Check Date
if grep -qE "Date: [0-9]{4}-[0-9]{2}-[0-9]{2}" "$FILE"; then
  echo "  OK: Date present"
else
  echo "FAIL: Missing or malformed Date"
  ERRORS=$((ERRORS + 1))
fi

# Check Mode
if grep -qE "Mode: (Full Retrospective|Checkpoint)" "$FILE"; then
  echo "  OK: Mode declared"
else
  echo "FAIL: Missing Mode declaration (Full Retrospective or Checkpoint)"
  ERRORS=$((ERRORS + 1))
fi

# Check Pipeline artifacts found
if grep -q "Pipeline artifacts found:" "$FILE"; then
  echo "  OK: Artifact list present"
else
  echo "WARN: Missing 'Pipeline artifacts found:' line"
  WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "--- Required Sections ---"

# Success Criteria Evaluation
if grep -qE "^## Success Criteria Evaluation" "$FILE"; then
  echo "  OK: Success Criteria Evaluation section"
  # Check for score summary
  if grep -qE "Score:" "$FILE"; then
    echo "  OK: Score summary present"
  else
    echo "WARN: Missing Score summary in Success Criteria"
    WARNINGS=$((WARNINGS + 1))
  fi
else
  echo "FAIL: Missing Success Criteria Evaluation section"
  ERRORS=$((ERRORS + 1))
fi

# Acceptance Criteria Coverage
if grep -qE "^## Acceptance Criteria Coverage" "$FILE"; then
  echo "  OK: Acceptance Criteria Coverage section"
  if grep -qE "Coverage:" "$FILE"; then
    echo "  OK: Coverage summary present"
  else
    echo "WARN: Missing Coverage summary"
    WARNINGS=$((WARNINGS + 1))
  fi
else
  echo "WARN: Missing Acceptance Criteria Coverage section (may be omitted if no SPEC)"
  WARNINGS=$((WARNINGS + 1))
fi

# Metrics
if grep -qE "^## Metrics" "$FILE"; then
  echo "  OK: Metrics section"
else
  echo "FAIL: Missing Metrics section"
  ERRORS=$((ERRORS + 1))
fi

# What Went Well
if grep -qE "^## What Went Well" "$FILE"; then
  echo "  OK: What Went Well section"
else
  echo "FAIL: Missing What Went Well section"
  ERRORS=$((ERRORS + 1))
fi

# What Didn't Go Well
if grep -qE "^## What Didn't Go Well" "$FILE"; then
  echo "  OK: What Didn't Go Well section"
else
  echo "FAIL: Missing What Didn't Go Well section"
  ERRORS=$((ERRORS + 1))
fi

# Lessons Learned
if grep -qE "^## Lessons Learned" "$FILE"; then
  echo "  OK: Lessons Learned section"
else
  echo "FAIL: Missing Lessons Learned section"
  ERRORS=$((ERRORS + 1))
fi

# Open Risks
if grep -qE "^## Open Risks" "$FILE"; then
  echo "  OK: Open Risks section"
else
  echo "WARN: Missing Open Risks section (may be empty if no open risks)"
  WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "--- Content Quality ---"

# Check that verdicts use standard values
VERDICT_COUNT=$(grep -cE "(PASS|FAIL|PARTIAL|UNTESTABLE|PROJECTED)" "$FILE" 2>/dev/null || echo "0")
if [[ "$VERDICT_COUNT" -eq 0 ]]; then
  echo "WARN: No standard verdict values found (PASS/FAIL/PARTIAL/UNTESTABLE/PROJECTED)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $VERDICT_COUNT verdict(s) using standard values"
fi

# Check for evidence in criteria table (look for pipe-separated table rows after Success Criteria heading)
TABLE_ROWS=$(grep -cE "^\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|" "$FILE" 2>/dev/null || echo "0")
if [[ "$TABLE_ROWS" -lt 2 ]]; then
  echo "WARN: Few table rows found — criteria tables may be incomplete"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $TABLE_ROWS table row(s) found"
fi

# Check for bullet points in narrative sections
BULLET_COUNT=$(grep -c "^- " "$FILE" 2>/dev/null || echo "0")
if [[ "$BULLET_COUNT" -lt 3 ]]; then
  echo "WARN: Fewer than 3 bullet points — narrative sections may be sparse"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $BULLET_COUNT bullet point(s) in narrative sections"
fi

# Checkpoint-specific: check for Remaining Work section
if grep -qE "Mode: Checkpoint" "$FILE"; then
  echo ""
  echo "--- Checkpoint Mode Checks ---"
  if grep -qE "^## Remaining Work" "$FILE"; then
    echo "  OK: Remaining Work section present"
  else
    echo "WARN: Checkpoint retro missing Remaining Work section"
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
