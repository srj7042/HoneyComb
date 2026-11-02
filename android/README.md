# Honeycomb for Android

Kotlin + Jetpack Compose (Material 3) frontend built on top of the shared Rust core,
invoked through UniFFI.

## Build Environment (macOS Apple Silicon Host)

Verified with JDK 25 and Android command-line tools installed via Homebrew.

### Prerequisites

```sh
# Rust Android compilation targets
rustup target add aarch64-linux-android x86_64-linux-android

# UniFFI cargo NDK helper
cargo install cargo-ndk --locked
```

Ensure Android SDK tools and NDK are configured (e.g. in `android/local.properties`):
```properties
sdk.dir=/opt/homebrew/share/android-commandlinetools
```

### Build Commands

From the `android/` directory:

```sh
# Build debug APK for physical devices (arm64) and emulators (x86_64)
./gradlew assembleDebug

# Run unit tests
./gradlew testDebugUnitTest
```

Gradle automatically compiles the Rust core with `cargo-ndk` (profile `android`: release
optimizations, symbols retained for UniFFI and stripped during APK packaging) and generates
the Kotlin bindings from the compiled `.so` library.

## Architecture & Subsystems

- `core/`: Kotlin-to-Rust bridge via UniFFI. `Core` manages the local node state machine and processes incoming events into `CoreState` (pure reducer with full unit-test coverage); `KeystoreKeyProtector` protects device identity keys with non-exportable Android Keystore keys; battery and network listeners feed telemetry to the core.
- `notifications/`: Android notification listener service (with user-granted notification access) forwarding notifications to the core for macOS mirroring, and interpreting action buttons and messaging-style replies from the Mac.
- `clipboard/`: Bidirectional clipboard synchronization with macOS. `SendActivity` handles share intents, Quick Settings tile triggers, and incoming text writes.
- `files/`: Handles incoming and outgoing file transfers. Received files are safely written to `Download/Honeycomb` (or MediaStore on Android 10+). Supports transfer progress and cancellations.
- `media/`: Exposes phone playback sessions to macOS, and provides native Android media controls for desktop playback.
- `service/ConnectionService`: Foreground service maintaining peer-to-peer QUIC connectivity and holding Wi-Fi multicast locks required for local mDNS discovery.
- `ui/`: Modern Material 3 UI with pairing support (CameraX + ZXing QR scanner, nearby pairing via 6-digit numeric verification), device settings, and theme customization.

Device identity is stored securely in `noBackupFilesDir` so it is never migrated across devices. Pairing QR links open Honeycomb directly for instant mutual trust establishment.

## Release & Signing

Release builds enable R8 code and resource shrinking (`isMinifyEnabled = true`, `isShrinkResources = true` with `proguard-rules.pro` keeping JNA, UniFFI bindings, Conscrypt, and Elevated shell helper entrypoints).

To sign locally for release:
```sh
export HONEYCOMB_KEYSTORE="/path/to/keystore.jks"
export HONEYCOMB_KEYSTORE_PASSWORD="your-password"
./gradlew assembleRelease
```
When the keystore environment variables are unset, Gradle falls back to debug signing for local test builds.
