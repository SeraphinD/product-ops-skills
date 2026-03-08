#!/usr/bin/env bash
# validate-spec.sh — Validates that a SPEC.md has all required sections and structure
# Usage: bash scripts/validate-spec.sh <path-to-spec>

set -euo pipefail

FILE="${1:?Usage: validate-spec.sh <path-to-SPEC.md>}"

if [[ ! -f "$FILE" ]]; then
  echo "ERROR: File not found: $FILE"
  exit 1
fi

ERRORS=0
WARNINGS=0

echo "=== Validating SPEC.md: $FILE ==="
echo ""

# Check title
echo "--- Structure ---"
if grep -qE "^# .+ - Specifications" "$FILE"; then
  echo "  OK: Title present"
else
  echo "FAIL: Missing title (# [Feature Name] - Specifications)"
  ERRORS=$((ERRORS + 1))
fi

# Check Generated from reference
if grep -q "Generated from:" "$FILE"; then
  echo "  OK: Generated from reference"
else
  echo "FAIL: Missing 'Generated from:' reference"
  ERRORS=$((ERRORS + 1))
fi

# Count User Stories
US_COUNT=$(grep -cE "^## User Story [0-9]+" "$FILE" 2>/dev/null || echo "0")
if [[ "$US_COUNT" -eq 0 ]]; then
  echo "FAIL: No User Stories found"
  ERRORS=$((ERRORS + 1))
else
  echo "  OK: $US_COUNT User Story(ies) found"
fi

# Check MoSCoW labels on User Stories
MOSCOW_COUNT=$(grep -cE "^## User Story [0-9]+ — (MUST|SHOULD|COULD|WON'T)" "$FILE" 2>/dev/null || echo "0")
UNLABELED=$((US_COUNT - MOSCOW_COUNT))
if [[ "$UNLABELED" -gt 0 ]]; then
  echo "WARN: $UNLABELED User Story(ies) missing MoSCoW label (MUST|SHOULD|COULD)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: All User Stories have MoSCoW labels"
fi

# Check Functional Scope sections
FS_COUNT=$(grep -cE "^### Functional Scope" "$FILE" 2>/dev/null || echo "0")
if [[ "$FS_COUNT" -lt "$US_COUNT" ]]; then
  echo "WARN: Only $FS_COUNT Functional Scope section(s) for $US_COUNT User Story(ies)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: Functional Scope sections match User Stories"
fi

# Check Acceptance Criteria sections
AC_COUNT=$(grep -cE "^### Acceptance Criteria" "$FILE" 2>/dev/null || echo "0")
if [[ "$AC_COUNT" -eq 0 ]]; then
  echo "FAIL: No Acceptance Criteria sections found"
  ERRORS=$((ERRORS + 1))
else
  echo "  OK: $AC_COUNT Acceptance Criteria section(s)"
fi

# Check Given/When/Then format
GIVEN_COUNT=$(grep -c "^\*\*GIVEN\*\*" "$FILE" 2>/dev/null || echo "0")
WHEN_COUNT=$(grep -c "^\*\*WHEN\*\*" "$FILE" 2>/dev/null || echo "0")
THEN_COUNT=$(grep -c "^\*\*THEN\*\*" "$FILE" 2>/dev/null || echo "0")
echo ""
echo "--- Acceptance Criteria Quality ---"
echo "  Scenarios: GIVEN=$GIVEN_COUNT, WHEN=$WHEN_COUNT, THEN=$THEN_COUNT"

if [[ "$GIVEN_COUNT" -ne "$WHEN_COUNT" || "$WHEN_COUNT" -ne "$THEN_COUNT" ]]; then
  echo "WARN: GIVEN/WHEN/THEN counts don't match — some scenarios may be incomplete"
  WARNINGS=$((WARNINGS + 1))
fi

if [[ "$GIVEN_COUNT" -lt 2 ]]; then
  echo "WARN: Fewer than 2 scenarios — should have at least happy path + error case"
  WARNINGS=$((WARNINGS + 1))
fi

# Check Implementation Notes
echo ""
echo "--- Optional Sections ---"
if grep -qE "^## Implementation Notes" "$FILE"; then
  echo "  OK: Implementation Notes present"
else
  echo "WARN: Missing Implementation Notes section"
  WARNINGS=$((WARNINGS + 1))
fi

# Check WON'T Stories section
if grep -qE "^## WON'T Stories" "$FILE"; then
  echo "  OK: WON'T Stories section present"
else
  echo "INFO: No WON'T Stories section (acceptable if no stories were excluded)"
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
