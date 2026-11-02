#!/bin/sh
# Copies the debug APK out under the Honeycomb artifact name.
set -eu
cd "$(dirname "$0")/.."
cd android
export ANDROID_HOME=${ANDROID_HOME:-/opt/homebrew/share/android-commandlinetools}
export PATH="$HOME/.cargo/bin:$PATH"
[ "${1:-}" = "--skip-build" ] || ./gradlew assembleDebug --console=plain
mkdir -p ../dist
cp app/build/outputs/apk/debug/app-debug.apk ../dist/Honeycomb-Android-debug.apk
echo "built: $(cd .. && pwd)/dist/Honeycomb-Android-debug.apk"
