#!/bin/sh
# Applies the Honeycomb display-name pass. Display strings only: protocol
# identifiers, package ids, crate names, the nectarlink:// scheme, the data
# directory and the Android applicationId are deliberately left alone.
set -eu
cd "$(dirname "$0")/.."

# QML: every string the window shows.
find desktop/app/qml -name '*.qml' -print0 | xargs -0 perl -pi -e 's/NectarLink/Honeycomb/g; s/Nectarlink/Honeycomb/g'

# Android: launcher label and user-facing copy, all locales.
find android/app/src/main/res -name 'strings.xml' -print0 | xargs -0 perl -pi -e 's/NectarLink/Honeycomb/g; s/Nectarlink/Honeycomb/g'

# macOS/desktop Rust: the platform layer that runs here plus shared screens.
# updater.rs keeps its release asset names: it talks to the upstream feed.
perl -pi -e 's/NectarLink/Honeycomb/g; s/Nectarlink/Honeycomb/g' \
  desktop/app/src/main.rs desktop/app/src/bridge/*.rs desktop/app/src/mac/*.rs
find desktop/app/src -maxdepth 1 -name '*.rs' ! -name 'main.rs' ! -name 'updater.rs' -print0 \
  | xargs -0 perl -pi -e 's/NectarLink/Honeycomb/g; s/Nectarlink/Honeycomb/g'

# Restore identifiers that must not move:
#  - the data directory holds the identity and trust store (pairing survives)
#  - the Windows shortcut filename is created by the installer, not by Rust
perl -pi -e 's/join\("Honeycomb"\)/join("Nectarlink")/ if /data_local_dir/' desktop/app/src/main.rs
perl -pi -e 's/Honeycomb\.lnk/NectarLink.lnk/g' desktop/app/src/setup.rs

# Product name in the embedded Windows resources and the notices header.
perl -pi -e 's/NectarLink/Honeycomb/g; s/Nectarlink/Honeycomb/g' \
  desktop/app/build.rs tools/xtask/src/notices.rs

# Core: messages a person can read (not wire names, not crate paths).
perl -pi -e 's/NectarLink/Honeycomb/g' \
  core/nectarlink-protocol/src/pairing.rs \
  core/nectarlink-core/src/store.rs \
  core/nectarlink-core/src/localsend.rs \
  core/nectarlink-cli/src/main.rs

echo "branding applied"
