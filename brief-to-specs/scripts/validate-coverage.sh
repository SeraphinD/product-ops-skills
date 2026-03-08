#!/usr/bin/env bash
# validate-coverage.sh — Cross-stage validation: checks if SPEC covers all BRIEF objectives
# Usage: bash scripts/validate-coverage.sh <path-to-brief> <path-to-spec>

set -euo pipefail

BRIEF="${1:?Usage: validate-coverage.sh <path-to-BRIEF.md> <path-to-SPEC.md>}"
SPEC="${2:?Usage: validate-coverage.sh <path-to-BRIEF.md> <path-to-SPEC.md>}"

if [[ ! -f "$BRIEF" ]]; then
  echo "ERROR: BRIEF not found: $BRIEF"
  exit 1
fi

if [[ ! -f "$SPEC" ]]; then
  echo "ERROR: SPEC not found: $SPEC"
  exit 1
fi

echo "=== Cross-Stage Validation: BRIEF → SPEC ==="
echo "  BRIEF: $BRIEF"
echo "  SPEC:  $SPEC"
echo ""

WARNINGS=0

# Extract objectives from BRIEF (lines starting with "- ✓" under "## Key Objectives")
echo "--- BRIEF Objectives Coverage ---"
OBJECTIVES=$(awk '/^## Key Objectives/{found=1; next} /^## /{if(found) exit} found && /^- ✓/' "$BRIEF" | sed 's/^- ✓ //')
OBJ_COUNT=0
COVERED=0

while IFS= read -r obj; do
  [[ -z "$obj" ]] && continue
  OBJ_COUNT=$((OBJ_COUNT + 1))
  # Extract key words (3+ chars) from the objective and check if they appear in the SPEC
  KEYWORDS=$(echo "$obj" | tr ' ' '\n' | awk 'length >= 4' | head -5)
  MATCH_COUNT=0
  for kw in $KEYWORDS; do
    if grep -qi "$kw" "$SPEC" 2>/dev/null; then
      MATCH_COUNT=$((MATCH_COUNT + 1))
    fi
  done
  if [[ "$MATCH_COUNT" -ge 2 ]]; then
    echo "  OK: \"$obj\""
    COVERED=$((COVERED + 1))
  else
    echo "WARN: Possibly uncovered — \"$obj\""
    WARNINGS=$((WARNINGS + 1))
  fi
done <<< "$OBJECTIVES"

echo ""
echo "  Coverage: $COVERED / $OBJ_COUNT objectives likely covered in SPEC"

# Check if BRIEF in-scope items appear in SPEC functional scope
echo ""
echo "--- BRIEF In-Scope Items Coverage ---"
INSCOPE=$(awk '/^### In Scope/{found=1; next} /^### |^## /{if(found) exit} found && /^- /' "$BRIEF" | sed 's/^- //')
IS_COUNT=0
IS_COVERED=0

while IFS= read -r item; do
  [[ -z "$item" ]] && continue
  IS_COUNT=$((IS_COUNT + 1))
  KEYWORDS=$(echo "$item" | tr ' ' '\n' | awk 'length >= 4' | head -5)
  MATCH_COUNT=0
  for kw in $KEYWORDS; do
    if grep -qi "$kw" "$SPEC" 2>/dev/null; then
      MATCH_COUNT=$((MATCH_COUNT + 1))
    fi
  done
  if [[ "$MATCH_COUNT" -ge 2 ]]; then
    echo "  OK: \"$item\""
    IS_COVERED=$((IS_COVERED + 1))
  else
    echo "WARN: Possibly uncovered — \"$item\""
    WARNINGS=$((WARNINGS + 1))
  fi
done <<< "$INSCOPE"

echo ""
echo "  Coverage: $IS_COVERED / $IS_COUNT in-scope items likely covered in SPEC"

# Check BRIEF success criteria have corresponding acceptance criteria
echo ""
echo "--- Success Criteria → Acceptance Criteria ---"
SC=$(awk '/^## Success Criteria/{found=1; next} /^## /{if(found) exit} found && /^- \[x\]/' "$BRIEF" | sed 's/^- \[x\] //')
SC_COUNT=0
SC_COVERED=0

while IFS= read -r criterion; do
  [[ -z "$criterion" ]] && continue
  SC_COUNT=$((SC_COUNT + 1))
  KEYWORDS=$(echo "$criterion" | tr ' ' '\n' | awk 'length >= 4' | head -5)
  MATCH_COUNT=0
  for kw in $KEYWORDS; do
    if grep -qi "$kw" "$SPEC" 2>/dev/null; then
      MATCH_COUNT=$((MATCH_COUNT + 1))
    fi
  done
  if [[ "$MATCH_COUNT" -ge 2 ]]; then
    echo "  OK: \"$criterion\""
    SC_COVERED=$((SC_COVERED + 1))
  else
    echo "WARN: Possibly uncovered — \"$criterion\""
    WARNINGS=$((WARNINGS + 1))
  fi
done <<< "$SC"

echo ""
echo "  Coverage: $SC_COVERED / $SC_COUNT success criteria likely have acceptance criteria"

echo ""
echo "=== Results ==="
if [[ "$WARNINGS" -eq 0 ]]; then
  echo "All BRIEF items appear covered in the SPEC."
  exit 0
else
  echo "$WARNINGS potential coverage gap(s) found."
  echo "Review the WARN items above — some may be false positives from keyword matching."
  exit 0
fi
