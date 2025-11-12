#!/usr/bin/env bash
set -e

echo "⚙️ Installing Android SDK and required components..."

ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/android-sdk}"
mkdir -p "$ANDROID_SDK_ROOT"
echo "✅ Created SDK directory at: $ANDROID_SDK_ROOT"

# Download command-line tools if not preinstalled
if [ ! -d "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin" ]; then
  echo "📦 Downloading Android command-line tools..."
  mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"
  cd "$ANDROID_SDK_ROOT/cmdline-tools"
  curl -sSL https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o cmdline-tools.zip
  unzip -q cmdline-tools.zip
  mv cmdline-tools latest
  rm cmdline-tools.zip
fi

export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"

echo "📦 Installing required Android packages..."
yes | sdkmanager --licenses > /dev/null
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

echo "✅ Android SDK installation complete."
