# ADR 0002 — App lifecycle and threading

**Status:** Accepted

## Context
MacMenu is a menu bar utility with no main window. It must stay responsive, mutate status items safely, and isolate failures when inspecting other (possibly hung) apps (Requirements 8.1, 8.3).

## Decision
Run as an **`LSUIElement`** menu bar app (no Dock icon by default, configurable). All `NSStatusItem` mutations happen on the **main thread** (AppKit requirement). App/UI **inspection** of other apps runs on background queues where the API allows, wrapped so a hung/quit app is isolated.

## Options considered
- **LSUIElement + main-thread mutation + backgrounded inspection (chosen)** — matches AppKit constraints and keeps UI responsive.
- **Regular windowed app** — unnecessary; a menu bar utility shouldn't occupy the Dock by default.
- **All work on the main thread** — risks freezes when inspecting a slow/hung app; rejected.

## Consequences
- Clear main-thread discipline for status-item changes.
- Inspection failures are contained (Requirement 8.1).
- Concurrency correctness is the main risk; mitigated with value types and tests in `Core`.
