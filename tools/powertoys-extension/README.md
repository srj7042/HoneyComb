# Launcher Command Palette Extension (`honeycomb-ptrun`)

`honeycomb-ptrun` is a standalone, zero-dependency Rust helper connecting external launcher tools (such as PowerToys Command Palette, Flow Launcher, or Raycast) to Honeycomb's [Local Authenticated API](../../docs/api.md).

## Building

```sh
cargo build --release --manifest-path tools/powertoys-extension/Cargo.toml
```

## Prerequisites

1. In Honeycomb, open **Settings → Local automation API** and enable **Enable local automation API**.
2. Honeycomb writes `api-token.json` containing the loopback port (`53320`) and an authentication Bearer token.

## Usage

### Querying Palette Items

```sh
honeycomb-ptrun query ""
honeycomb-ptrun query "ring"
```

Outputs a JSON array of palette commands (`send-clipboard`, `ring`, `camera photo`, `send-url`, `send-text`, etc.).

### Invoking an Action

```sh
honeycomb-ptrun invoke ring
honeycomb-ptrun invoke send-clipboard
honeycomb-ptrun invoke camera photo
honeycomb-ptrun invoke send-url "https://example.com"
honeycomb-ptrun invoke send-text "Copied from launcher"
honeycomb-ptrun invoke send-file "/Users/surajjaiswal/Downloads/document.pdf"
```
