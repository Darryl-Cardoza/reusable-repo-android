#!/usr/bin/env bash
set -euo pipefail

# Summarize Detekt results from XML or TXT.
# Usage: ./tool/scripts/lint_summary.sh app/build/reports/detekt
DIR="${1:-app/build/reports/detekt}"

XML="${DIR}/detekt.xml"
TXT="${DIR}/detekt.txt"
HTML="${DIR}/detekt.html"

if [[ -f "$XML" ]]; then
  ERRORS=$(grep -o '<error ' "$XML" | wc -l | tr -d ' ')
  echo "Detekt: ${ERRORS} issues (xml)"
elif [[ -f "$TXT" ]]; then
  # Count lines that look like findings (heuristic)
  ISSUES=$(grep -E '^(.*): (.*) - .+ \[.*\]$' "$TXT" | wc -l | tr -d ' ')
  echo "Detekt: ${ISSUES} issues (txt)"
elif [[ -f "$HTML" ]]; then
  # Fallback: count occurrences of severity tags
  ISSUES=$(grep -oE 'Severity\:' "$HTML" | wc -l | tr -d ' ')
  echo "Detekt: ${ISSUES} issues (html est.)"
else
  echo "Detekt: no report found in $DIR"
  exit 1
fi
