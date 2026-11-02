# Fonts

The typefaces both Honeycomb apps ship with, as specified in `docs/design/tokens.json`.
All fonts are licensed under the [SIL Open Font License 1.1](https://openfontlicense.org);
each license file sits next to its font and is packaged with it.

| File | Family | Used for |
|---|---|---|
| `Figtree.ttf` | Figtree (variable, weights 300 to 900) | Primary UI typography; body text in Graphite |
| `InstrumentSerif-Regular.ttf` | Instrument Serif | Distinctive headings |
| `SpaceMono-Regular.ttf`, `SpaceMono-Bold.ttf` | Space Mono | Numeric verification codes, device IDs, and technical annotations |

Origin: Retrieved unmodified from [google/fonts](https://github.com/google/fonts) at commit `6e8069ff8ba3dab2a397fb30e7fbd243aba9b57a` (`ofl/figtree`, `ofl/instrumentserif`, `ofl/spacemono`).

- The macOS desktop application embeds these fonts at compile time via `desktop/app/build.rs`.
- The Android application packages this directory as application assets via `android/app/build.gradle.kts`.
