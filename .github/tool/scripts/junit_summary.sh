#!/usr/bin/env bash
set -euo pipefail

# Summarize JUnit test results from XML files.
# Usage: ./tool/scripts/junit_summary.sh app/build/test-results
ROOT="${1:-app/build/test-results}"

# find all .xml files under root
FILES=$(find "$ROOT" -type f -name "*.xml" 2>/dev/null || true)
if [[ -z "${FILES}" ]]; then
  echo "JUnit: no XML reports under $ROOT"
  exit 1
fi

TOTAL=0
FAIL=0
SKIP=0

for f in $FILES; do
  t=$(grep -oE 'tests="[0-9]+"' "$f" | head -1 | sed -E 's/tests="([0-9]+)"/\1/')
  f1=$(grep -oE 'failures="[0-9]+"' "$f" | head -1 | sed -E 's/failures="([0-9]+)"/\1/')
  e1=$(grep -oE 'errors="[0-9]+"' "$f" | head -1 | sed -E 's/errors="([0-9]+)"/\1/')
  s=$(grep -oE 'skipped="[0-9]+"' "$f" | head -1 | sed -E 's/skipped="([0-9]+)"/\1/')

  t=${t:-0}; f1=${f1:-0}; e1=${e1:-0}; s=${s:-0}
  TOTAL=$((TOTAL + t))
  FAIL=$((FAIL + f1 + e1))
  SKIP=$((SKIP + s))
done

PASSED=$((TOTAL - FAIL - SKIP))
echo "JUnit: total=$TOTAL, passed=$PASSED, failed=$FAIL, skipped=$SKIP"
