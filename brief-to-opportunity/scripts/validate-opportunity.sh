#!/usr/bin/env bash
# validate-opportunity.sh — Validates that an OPPORTUNITY.md has correct structure and valid scores
# Usage: bash scripts/validate-opportunity.sh <path-to-OPPORTUNITY.md>

set -euo pipefail

FILE="${1:?Usage: validate-opportunity.sh <path-to-OPPORTUNITY.md>}"

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

echo "=== Validating OPPORTUNITY.md: $FILE ==="
echo ""

# Check required sections
echo "--- Required Sections ---"
check_section "^# Opportunity:" "Title (# Opportunity: ...)"
check_section "^## RICE Score:" "RICE Score header"

echo ""
echo "--- Header Metadata ---"

# Check for generated-from line
if grep -qE "Generated from:" "$FILE"; then
  echo "  OK: Generated from reference present"
else
  echo "FAIL: Missing 'Generated from:' reference to source BRIEF"
  ERRORS=$((ERRORS + 1))
fi

# Check for method line
if grep -qE "Method: RICE" "$FILE"; then
  echo "  OK: RICE method declared"
else
  echo "WARN: Missing method declaration"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for weight declaration
if grep -qE "Impact weights:" "$FILE"; then
  echo "  OK: Impact weights declared"
else
  echo "WARN: Missing impact weights declaration"
  WARNINGS=$((WARNINGS + 1))
fi

# Check for date
if grep -qE "Date:" "$FILE"; then
  echo "  OK: Date present"
else
  echo "WARN: Missing date"
  WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "--- Score Card ---"

# Check all four impact dimensions are present
for dim in "Strategic Impact" "Business Impact" "User Impact" "Internal Impact"; do
  if grep -qE "^\| $dim" "$FILE"; then
    echo "  OK: $dim present"
  else
    echo "FAIL: Missing $dim row in score card"
    ERRORS=$((ERRORS + 1))
  fi
done

# Check weighted average row
if grep -qE "Impact \(weighted avg\)" "$FILE"; then
  echo "  OK: Impact weighted average present"
else
  echo "FAIL: Missing Impact (weighted avg) row"
  ERRORS=$((ERRORS + 1))
fi

# Check Reach, Confidence, Effort rows
for factor in "Reach" "Confidence" "Effort"; do
  if grep -qE "^\| $factor" "$FILE"; then
    echo "  OK: $factor present"
  else
    echo "FAIL: Missing $factor row in score card"
    ERRORS=$((ERRORS + 1))
  fi
done

echo ""
echo "--- Score Validity ---"

# Check for valid Fibonacci values in impact scores (1, 2, 3, 5, 8, 13)
VALID_FIB="^(1|2|3|5|8|13)$"
IMPACT_VALUES=$(grep -E '^\| (Strategic|Business|User|Internal) Impact' "$FILE" | awk -F'|' '{gsub(/[ ]+/, "", $3); print $3}' 2>/dev/null || true)

if [[ -n "$IMPACT_VALUES" ]]; then
  INVALID=0
  while IFS= read -r val; do
    if ! echo "$val" | grep -qE "$VALID_FIB"; then
      echo "FAIL: Invalid Fibonacci value for impact: $val (must be 1, 2, 3, 5, 8, 13)"
      ERRORS=$((ERRORS + 1))
      INVALID=$((INVALID + 1))
    fi
  done <<< "$IMPACT_VALUES"
  if [[ "$INVALID" -eq 0 ]]; then
    echo "  OK: All impact values are valid Fibonacci"
  fi
fi

# Check effort value
EFFORT_VALUES=$(grep -E '^\| Effort' "$FILE" | awk -F'|' '{gsub(/[ ]+/, "", $3); gsub(/ person-weeks/, "", $3); print $3}' 2>/dev/null || true)

if [[ -n "$EFFORT_VALUES" ]]; then
  INVALID=0
  while IFS= read -r val; do
    if ! echo "$val" | grep -qE "$VALID_FIB"; then
      echo "FAIL: Invalid Fibonacci value for effort: $val (must be 1, 2, 3, 5, 8, 13)"
      ERRORS=$((ERRORS + 1))
      INVALID=$((INVALID + 1))
    fi
  done <<< "$EFFORT_VALUES"
  if [[ "$INVALID" -eq 0 ]]; then
    echo "  OK: Effort value is valid Fibonacci"
  fi
fi

# Check confidence value
CONF_VALUES=$(grep -E '^\| Confidence' "$FILE" | awk -F'|' '{gsub(/[ %]+/, "", $3); print $3}' 2>/dev/null || true)

if [[ -n "$CONF_VALUES" ]]; then
  INVALID=0
  while IFS= read -r val; do
    if ! echo "$val" | grep -qE "^(50|80|100)$"; then
      echo "FAIL: Invalid confidence value: $val% (must be 50%, 80%, or 100%)"
      ERRORS=$((ERRORS + 1))
      INVALID=$((INVALID + 1))
    fi
  done <<< "$CONF_VALUES"
  if [[ "$INVALID" -eq 0 ]]; then
    echo "  OK: Confidence value is valid (50/80/100%)"
  fi
fi

# Check reach is a percentage
REACH_VALUES=$(grep -E '^\| Reach' "$FILE" | awk -F'|' '{gsub(/[% a-zA-Z]+/, "", $3); print $3}' 2>/dev/null || true)

if [[ -n "$REACH_VALUES" ]]; then
  INVALID=0
  while IFS= read -r val; do
    if [[ "$val" -lt 1 || "$val" -gt 100 ]] 2>/dev/null; then
      echo "FAIL: Reach value out of range: $val (must be 1–100%)"
      ERRORS=$((ERRORS + 1))
      INVALID=$((INVALID + 1))
    fi
  done <<< "$REACH_VALUES"
  if [[ "$INVALID" -eq 0 ]]; then
    echo "  OK: Reach value is valid percentage"
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
