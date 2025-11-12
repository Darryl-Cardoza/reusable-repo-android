#!/usr/bin/env bash
set -euo pipefail

# Parse total coverage percentage from Kover HTML (preferred) or XML fallback.
# Usage:
#   ./tool/scripts/parse_coverage.sh \
#     --html app/build/reports/kover/html/index.html \
#     --xml  app/build/reports/kover/xml/report.xml

HTML=""
XML=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --html) HTML="${2:-}"; shift 2 ;;
    --xml)  XML="${2:-}"; shift 2 ;;
    *) echo "Unknown arg: $1" ; exit 2 ;;
  esac
done

extract_from_html () {
  local f="$1"
  # Grep first % found near 'Total' row
  grep -oE 'Total[^%]*([0-9]+\.[0-9]+)%' "$f" | head -1 | grep -oE '[0-9]+\.[0-9]+'
}

extract_from_xml () {
  local f="$1"
  # Try to detect lineRate from cobertura-like XML (Kover XML uses a similar schema)
  # Example attribute: line-rate="0.83"
  local rate
  rate=$(grep -oE 'line-rate="[0-9]+\.[0-9]+"' "$f" | head -1 | sed -E 's/line-rate="([0-9]+\.[0-9]+)"/\1/')
  if [[ -n "${rate:-}" ]]; then
    awk -v r="$rate" 'BEGIN{printf "%.2f\n", (r*100)}'
  fi
}

PCT=""

if [[ -n "${HTML}" && -f "${HTML}" ]]; then
  PCT=$(extract_from_html "${HTML}" || true)
fi

if [[ -z "${PCT}" && -n "${XML}" && -f "${XML}" ]]; then
  PCT=$(extract_from_xml "${XML}" || true)
fi

if [[ -z "${PCT}" ]]; then
  echo "Coverage: N/A"
  exit 1
else
  echo "Coverage: ${PCT}%"
fi
