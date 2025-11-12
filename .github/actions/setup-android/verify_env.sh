#!/usr/bin/env bash
set -e

echo "🔍 Verifying Android SDK environment..."

if ! command -v adb >/dev/null 2>&1; then
  echo "❌ adb not found in PATH."
  echo "PATH is: $PATH"
  echo "Please ensure platform-tools are installed and exported."
  exit 1
fi

if ! command -v sdkmanager >/dev/null 2>&1; then
  echo "❌ sdkmanager not found in PATH."
  exit 1
fi

if ! command -v java >/dev/null 2>&1; then
  echo "❌ Java not found."
  exit 1
fi

echo "✅ Android SDK, adb, and Java verified successfully."
