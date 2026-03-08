#!/usr/bin/env bash
# validate-benchmark.sh — Validates that a BENCHMARK.md has all required sections and structure
# Usage: bash scripts/validate-benchmark.sh <path-to-benchmark>

set -euo pipefail

FILE="${1:?Usage: validate-benchmark.sh <path-to-BENCHMARK.md>}"

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

echo "=== Validating BENCHMARK.md: $FILE ==="
echo ""

# --- Structure ---
echo "--- Required Sections ---"
check_section "^# Benchmark:" "Title (# Benchmark: ...)"
check_section "Generated from:" "Generated from reference"
check_section "^## Comparable Solutions" "Comparable Solutions"
check_section "^## Technical Standards" "Technical Standards"
check_section "^## Key Metrics" "Key Metrics & Baselines"
check_section "^## Gap Analysis" "Gap Analysis"
check_section "^## Spec Recommendations" "Spec Recommendations"

echo ""
echo "--- Gap Analysis Sub-sections ---"
check_section "What Existing Solutions Don't Cover" "Gaps — What Existing Solutions Don't Cover"
check_section "What Your Brief Overlaps With" "Gaps — What Your Brief Overlaps With"
check_section "Risks & Considerations" "Gaps — Risks & Considerations"

echo ""
echo "--- Spec Recommendations Sub-sections ---"
if grep -q "^\- \*\*Include:\*\*\|^\- \*\*Include\*\*" "$FILE"; then
  echo "  OK: Include recommendation(s)"
else
  echo "WARN: No 'Include' recommendation found"
  WARNINGS=$((WARNINGS + 1))
fi

if grep -q "^\- \*\*Exclude\|^\- \*\*Exclude (for now)" "$FILE"; then
  echo "  OK: Exclude recommendation(s)"
else
  echo "WARN: No 'Exclude' recommendation found"
  WARNINGS=$((WARNINGS + 1))
fi

if grep -q "^\- \*\*Validate before specifying\*\*\|^\- \*\*Validate\*\*" "$FILE"; then
  echo "  OK: Validate-before-specifying recommendation(s)"
else
  echo "WARN: No 'Validate before specifying' recommendation found"
  WARNINGS=$((WARNINGS + 1))
fi

# --- Comparable Solutions count ---
echo ""
echo "--- Content Quality ---"
COMP_COUNT=$(grep -cE "^### " "$FILE" 2>/dev/null || echo "0")
# Subtract known non-competitor ### headers
SUB_HEADERS=$(grep -cE "^### (What Existing|What Your Brief|Risks &|Competitor Layout|User Flow)" "$FILE" 2>/dev/null || echo "0")
COMP_COUNT=$((COMP_COUNT - SUB_HEADERS))
if [[ "$COMP_COUNT" -lt 3 ]]; then
  echo "WARN: Only $COMP_COUNT comparable solution(s) found (minimum: 3)"
  WARNINGS=$((WARNINGS + 1))
elif [[ "$COMP_COUNT" -gt 5 ]]; then
  echo "WARN: $COMP_COUNT comparable solutions found (maximum: 5)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: $COMP_COUNT comparable solution(s)"
fi

# --- Metrics table ---
TABLE_ROWS=$(grep -cE "^\|.*\|.*\|.*\|" "$FILE" 2>/dev/null || echo "0")
# Subtract header and separator rows (at least 2 per table)
if [[ "$TABLE_ROWS" -lt 5 ]]; then
  echo "WARN: Metrics table may have fewer than 3 data rows (found $TABLE_ROWS total table rows)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  OK: Metrics table has $TABLE_ROWS rows"
fi

# --- Unverified flags ---
UNVERIFIED_COUNT=$(grep -c "⚠️" "$FILE" 2>/dev/null || echo "0")
if [[ "$UNVERIFIED_COUNT" -gt 0 ]]; then
  echo "INFO: $UNVERIFIED_COUNT unverified item(s) flagged with ⚠️ (this is expected)"
else
  echo "  OK: No unverified items (all data sourced)"
fi

# --- Visual References (optional, frontend only) ---
echo ""
echo "--- Optional Sections ---"
if grep -qE "^## Visual References" "$FILE"; then
  echo "  OK: Visual References section present (frontend feature)"
  # Check for diagrams
  DIAGRAM_COUNT=$(grep -c '┌\|┐\|└\|┘\|│\|─' "$FILE" 2>/dev/null || echo "0")
  if [[ "$DIAGRAM_COUNT" -gt 0 ]]; then
    echo "  OK: Unicode box-drawing diagrams found"
  else
    echo "WARN: Visual References section exists but no Unicode diagrams found"
    WARNINGS=$((WARNINGS + 1))
  fi
  MERMAID_COUNT=$(grep -c "flowchart\|graph " "$FILE" 2>/dev/null || echo "0")
  if [[ "$MERMAID_COUNT" -gt 0 ]]; then
    echo "  OK: Mermaid flow diagrams found"
  else
    echo "WARN: Visual References section exists but no Mermaid diagrams found"
    WARNINGS=$((WARNINGS + 1))
  fi
else
  echo "INFO: No Visual References section (OK for non-frontend features)"
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
