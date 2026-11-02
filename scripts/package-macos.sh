#!/bin/sh
# Builds Honeycomb.app and Honeycomb-macOS.dmg from this checkout.
# Usage: scripts/package-macos.sh [--skip-build]
# Output: dist/Honeycomb.app, dist/Honeycomb-macOS.dmg
set -eu

cd "$(dirname "$0")/.."
ROOT=$(pwd)
VERSION=$(sed -n 's/^version = "\(.*\)"/\1/p' Cargo.toml | head -1)
DIST="$ROOT/dist"
APP="$DIST/Honeycomb.app"
QT_PREFIX=${QT_PREFIX:-$(brew --prefix qt 2>/dev/null || echo /opt/homebrew/opt/qt)}

if [ "${1:-}" != "--skip-build" ]; then
  PATH="$HOME/.cargo/bin:$PATH" cargo build --locked --release -p nectarlink-desktop
fi

BIN="$ROOT/target/release/nectarlink-desktop"
[ -x "$BIN" ] || { echo "missing $BIN" >&2; exit 1; }

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/Honeycomb"

# Icon: assets/brand/icon-512.png -> Honeycomb.icns
ICONSET="$DIST/Honeycomb.iconset"
rm -rf "$ICONSET"; mkdir -p "$ICONSET"
for s in 16 32 64 128 256 512; do
  sips -z $s $s "$ROOT/assets/brand/icon-512.png" --out "$ICONSET/icon_${s}x${s}.png" >/dev/null
  d=$((s * 2))
  sips -z $d $d "$ROOT/assets/brand/icon-512.png" --out "$ICONSET/icon_${s}x${s}@2x.png" >/dev/null
done
iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/Honeycomb.icns"
rm -rf "$ICONSET"

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>Honeycomb</string>
  <key>CFBundleDisplayName</key><string>Honeycomb</string>
  <key>CFBundleExecutable</key><string>Honeycomb</string>
  <key>CFBundleIdentifier</key><string>app.honeycomb.desktop</string>
  <key>CFBundleIconFile</key><string>Honeycomb</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>${VERSION}</string>
  <key>CFBundleVersion</key><string>${VERSION}</string>
  <key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
  <key>LSMinimumSystemVersion</key><string>14.0</string>
  <key>LSApplicationCategoryType</key><string>public.app-category.utilities</string>
  <key>NSHighResolutionCapable</key><true/>
  <key>NSHumanReadableCopyright</key><string>GPL-3.0-or-later. Based on NectarLink by The NectarLink contributors.</string>
  <key>NSLocalNetworkUsageDescription</key><string>Honeycomb finds and connects to your Android phone on your local network.</string>
  <key>NSCameraUsageDescription</key><string>Honeycomb uses the camera to scan the pairing code.</string>
  <key>NSMicrophoneUsageDescription</key><string>Honeycomb can use the phone's microphone as your Mac's input.</string>
  <key>NSAppleEventsUsageDescription</key><string>Honeycomb opens links and files on your Mac on your behalf.</string>
</dict>
</plist>
PLIST

# Qt frameworks, QML modules and plugins.
if [ -x "$QT_PREFIX/bin/macdeployqt" ]; then
  "$QT_PREFIX/bin/macdeployqt" "$APP" -always-overwrite >/dev/null
else
  echo "warning: macdeployqt not found under $QT_PREFIX; the app needs Qt installed" >&2
fi

codesign --force --deep --sign - "$APP" 2>/dev/null

rm -f "$DIST/Honeycomb-macOS.dmg"
hdiutil create -volname Honeycomb -srcfolder "$APP" -ov -format UDZO \
  "$DIST/Honeycomb-macOS.dmg" >/dev/null

echo "built:"
echo "  $APP"
echo "  $DIST/Honeycomb-macOS.dmg"
