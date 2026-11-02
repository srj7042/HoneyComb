# The Honeycomb mark

The visual identity represents seamless cross-device connection: two loops—phone and Mac—surrounding a central warm core, evoking connection, continuity, and flow.

| File | What it is |
|---|---|
| `icon.svg` | The full-color app icon: espresso tile, warm glow, honey rim |
| `icon-flat.svg` | The flat variant without glow and highlights, for flat UI contexts |
| `icon-mono.svg` | Monochrome white mark for one-color contexts (status bar, notifications, themed icons) |
| `icon-512.png` | `icon.svg` rendered at 512 × 512 |

The apps draw the mark from unified vector geometry:
- macOS desktop application (`desktop/app/src/mark.rs` and icon assets)
- Android launcher and notification icons (`android/app/src/main/res/drawable/ic_launcher_*.xml` and `ic_notification.xml`)

Colors (Honey palette, `docs/design/tokens.json`):
- Background tile: `#2C1600`
- Ambient glow: `#693C00`
- Phone loop: `#FFF8F3`
- Mac loop: `#FFDDB8`
- Central core and rim: `#FFB95F`

The name and visual identity are covered by the [trademark policy](../../doc/TRADEMARKS.md).
