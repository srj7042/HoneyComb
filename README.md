# Honeycomb

A seamless, open-source device companion linking Android devices and macOS.

---

## About the Project

**Honeycomb** is a cross-device integration suite designed to bridge Android and macOS into a unified, secure workspace. Honeycomb is tailored specifically for macOS running on Apple Silicon (M1/M2/M3/M4, macOS 14+) alongside a companion Android application built with Kotlin and Jetpack Compose.

Unlike cloud-dependent continuity tools, Honeycomb operates peer-to-peer over local network transports (mDNS local discovery, QUIC, and mutual TLS 1.3), as well as direct USB/ADB connections. Your clipboard contents, files, photos, notifications, and messages transfer directly between your phone and your Mac without routing through any external cloud server or third-party service.

---

## Architecture

Honeycomb follows a modular, cross-platform architecture that combines a high-performance shared Rust engine with native frontends and platform integrations:

```
┌──────────────────────────────────────────────────────────┐
│                   Desktop Application                    │
│            Qt 6 Quick / QML User Interface               │
│                          ▲                               │
│                          │ cxx-qt bridge                 │
│                          ▼                               │
│     Rust Host Runtime (tokio) ── macOS Platform Layer    │
│            (VideoToolbox, NSPasteboard, CoreAudio)       │
└──────────────────────────┬───────────────────────────────┘
                           │
                 Shared Rust Core Engine
         (Session management, Trust store, Cryptography)
                           │
       Peer-to-Peer Transport (iroh QUIC + Mutual TLS 1.3)
                  Local mDNS / USB ADB Tunnel
                           │
┌──────────────────────────▼───────────────────────────────┐
│                    Android Application                   │
│         Kotlin + Jetpack Compose (Material 3 UI)         │
│                          ▲                               │
│                          │ UniFFI bindings               │
│                          ▼                               │
│         Native Rust Core Bridge on Android               │
└──────────────────────────────────────────────────────────┘
```

### Core Subsystems

1. **Shared Rust Core (`core/`)**:
   - `core-engine`: Manages local identity, ed25519 device keys, encrypted trust store, pairing state machines, and feature services (file streaming, clipboard history, notification sync).
   - `core-protocol`: Versioned CBOR wire protocol defining message schemas, pairing handshakes, and dynamic capability negotiation.
   - `core-ffi`: UniFFI-generated C/Kotlin foreign function interface exposing core capabilities to Android.
   - `core-adb`: Built-in ADB transport helper for local USB tunneling and pairing without network dependencies.

2. **macOS Desktop Client (`desktop/app`)**:
   - Built with **Qt 6 Quick** and **cxx-qt**, providing hardware-accelerated fluid UI rendering.
   - Native macOS platform integrations (`src/mac/`):
     - **Clipboard**: Native `NSPasteboard` integration for bidirectional text sharing.
     - **Media & Hardware Acceleration**: `VideoToolbox` for hardware H.264 decoding; `CoreGraphics` for image processing.
     - **Audio**: `CoreAudio` for low-latency feedback.
     - **Notifications**: System notification dispatch via AppleScript runner.
     - **System Lifecycle**: `launchd` login item integration, `NSWorkspace` URL opening, and single-instance locks.

3. **Android Client (`android/app`)**:
   - Built in **Kotlin** and **Jetpack Compose** using Material 3 guidelines.
   - Communicates with the Rust engine through native dynamic libraries compiled via `cargo-ndk`.
   - Utilizes Android Keystore for non-exportable hardware-backed key protection.
   - Hooks into Android notification listeners, telephony/SMS APIs, and MediaStore.

4. **Transport & Security**:
   - Direct peer-to-peer transport using **iroh** (QUIC + mutual TLS 1.3).
   - Secure local discovery using mDNS.
   - End-to-end encrypted: zero external servers, tracking, or cloud relays required.

---

## Features

### Seamless Continuity
- **Bidirectional Clipboard Sync**: Seamlessly copy text on Android and paste on macOS (or vice versa). Supports incoming image clipboard streaming.
- **Fast File & Folder Transfers**: Resumable, direct local transfer of documents, folders, and archives with integrity verification.
- **Photo Gallery Access**: Browse and download photos from your phone camera roll directly onto your Mac without manual syncing.
- **Notification Mirroring**: Incoming Android app alerts and notifications stream to macOS notification banners in real time.
- **SMS & Messaging**: View incoming SMS/MMS conversations and reply directly from your desktop.
- **Call Management**: Receive incoming call alerts on your Mac with quick actions to answer or decline.
- **Quick Controls & Telemetry**: Inspect phone battery level, charging status, Wi-Fi signal, and adjust phone volume or toggles from macOS.
- **Continuity Camera**: Trigger instant camera capture from your phone and receive high-resolution photos straight into your macOS workflow.
- **Link & Text Handoff**: Instantly push URLs, text snippets, and notes between phone and Mac.

### Privacy & Reliability
- **Local-First & Offline Capable**: Operates entirely over local Wi-Fi or USB cable without an internet connection.
- **End-to-End Encryption**: Every packet is encrypted with mutual TLS 1.3 using ephemeral session keys.
- **Apple Silicon Optimized**: Native ARM64 binary execution on Apple M-series chips for minimal CPU and battery consumption.

---

## License

- **Desktop Application, Android Application & CLI**: Licensed under the [GNU General Public License v3.0 or later (GPL-3.0-or-later)](LICENSES/GPL-3.0-or-later.txt) with an [App Store Exception](LICENSES/APP-STORE-EXCEPTION.md).
- **Core Libraries**: Licensed under the [Mozilla Public License 2.0 (MPL-2.0)](LICENSES/MPL-2.0.txt).
- **Protocol Specification & Documentation**: Licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSES/CC-BY-4.0.txt).
