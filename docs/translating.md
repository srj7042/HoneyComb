# Translating Honeycomb

Honeycomb's Android and macOS desktop apps can be translated into any language.

## How to help

In a pull request, edit the translation files directly:

- **Android**: `android/app/src/main/res/values-<language>/strings.xml`, for example
  `values-de/strings.xml` or `values-pt-rBR/strings.xml`. Copy entries
  from `values/strings.xml` and translate the text. Keep placeholders such as
  `%1$s` and `%2$d` intact; their order in the sentence can change.
- **Desktop (macOS)**: `desktop/app/i18n/honeycomb_<language>.ts`, for example
  `honeycomb_de.ts`. Start a new language by copying
  `desktop/app/i18n/template/honeycomb.ts`, then fill in the `<translation>`
  elements with Qt Linguist or a text editor. Placeholders are `%1`, `%2`, etc.

Guidelines for consistency:
- Name each language in its native form in pickers ("Deutsch", "Español", "हिन्दी", "简体中文").
- Keep the product name "Honeycomb" as it is.
- Short UI labels stay concise to fit the native layout.

## Partly translated languages

A language can be submitted while in progress:
- **Android**: The APK packages languages configured in `android/app/src/main/res/xml/locales_config.xml`.
- **Desktop**: The desktop app compiles catalogues listed in `i18n::LANGUAGES` (`desktop/app/src/i18n.rs`).

## For developers: keeping catalogues current

- Android strings live in `values/strings.xml`.
- On desktop, after changing text in QML or Rust (`tr!`), update the string headers:

```sh
cargo xtask strings
lupdate desktop/app/qml desktop/app/i18n/rust_strings.h -ts desktop/app/i18n/honeycomb_*.ts desktop/app/i18n/template/honeycomb.ts
```
