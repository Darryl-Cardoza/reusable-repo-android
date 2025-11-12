#!/usr/bin/env bash
set -e

echo "📦 Installing Android SDK and build tools..."

# Create SDK directory
sudo mkdir -p /usr/local/android-sdk
cd /usr/local/android-sdk

# Download command line tools
wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip

# Extract and organize
sudo unzip -q cmdline-tools.zip -d cmdline-tools
sudo mkdir -p cmdline-tools/latest
sudo mv cmdline-tools/cmdline-tools/* cmdline-tools/latest/

# Set environment variables
echo "ANDROID_HOME=/usr/local/android-sdk" | sudo tee -a /etc/environment
echo "PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools" | sudo tee -a /etc/environment
source /etc/environment

# Accept licenses and install SDK packages
yes | sudo cmdline-tools/latest/bin/sdkmanager --sdk_root=/usr/local/android-sdk --licenses
sudo cmdline-tools/latest/bin/sdkmanager --sdk_root=/usr/local/android-sdk \
  "platform-tools" \
  "platforms;android-34" \
  "build-tools;34.0.0"

echo "✅ Android SDK installed successfully!"
