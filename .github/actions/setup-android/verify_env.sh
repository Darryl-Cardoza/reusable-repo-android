#!/usr/bin/env bash
set -e

echo "🔍 Verifying Android SDK and environment setup..."

if [ -z "$ANDROID_HOME" ]; then
  echo "❌ ANDROID_HOME not set!"
  exit 1
fi

if [ ! -d "$ANDROID_HOME/platform-tools" ]; then
  echo "❌ platform-tools directory missing!"
  exit 1
fi

adb_version=$(adb version || true)
if [[ $adb_version == *"Android Debug Bridge"* ]]; then
  echo "✅ ADB verified: $adb_version"
else
  echo "⚠️ Warning: ADB not found in PATH"
fi

echo "🧩 Environment summary:"
echo "ANDROID_HOME: $ANDROID_HOME"
echo "PATH: $PATH"
echo "Build Tools:"
ls "$ANDROID_HOME/build-tools" || echo "No build-tools found"

echo "✅ Android environment verification complete."
