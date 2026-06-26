# ADR 0001 — Language and UI stack

**Status:** Accepted

## Context
MacMenu needs low-level control over menu bar status items and a small preferences UI. The author is learning native macOS development. Alternatives like Tauri or Electron were considered.

## Decision
Build natively with **Swift**, using **AppKit** for the menu bar control and status-item manipulation, and **SwiftUI** for preferences and onboarding (via `NSHostingView` where embedded).

## Options considered
- **Swift + AppKit/SwiftUI (chosen)** — AppKit gives the fine-grained `NSStatusItem` control the spacer technique requires; best learning value.
- **Tauri (Rust + React)** — would need native bridging for all menu bar work, defeating the purpose.
- **Electron** — cannot manipulate the system menu bar meaningfully; rejected.

## Consequences
- Direct, idiomatic access to `NSStatusBar`/`NSStatusItem`.
- Steeper learning curve (AppKit is new), accepted as a goal.
- UI split across AppKit (menu bar) and SwiftUI (prefs); interop patterns to learn.
