# Pure-Omega Cortex Memory Engine (superseding cortex-rs)

This directory carries the complete pure seeded Omega (.om) Cortex HTTP memory server, full-text search engine, durable CRC32C log, and SQLite importer (synced from omega-mv core/cortex/om/ at f840a6ee9a835e22836609391176596fa911be70, seed/out/omc sha256 708fdc0f81866594ed6df2f492b7a8a6bc7456f2d733a838b7f840549ebba6c3).

The legacy Rust files under src/ are superseded by this pure-Omega engine and kept only for historical reference until final archive cutover.

- Build and verify: `OMC=/path/to/seed/out/omc sh om/gate.sh`
