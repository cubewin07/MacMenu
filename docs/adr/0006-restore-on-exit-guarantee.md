# ADR 0006 — Restore-on-exit guarantee

**Status:** Accepted

## Context
MacMenu deliberately alters the visible state of *other apps'* menu bar items (via spacer widths). If it exits — normally or by crashing — without undoing this, the user's menu bar could be left in a broken or confusing state. This is the single most important reliability property (Requirement 8.2).

## Decision
MacMenu MUST restore the menu bar to its normal state whenever it stops managing it. `restoreAll()` resets all spacer widths/positions. It is invoked on:
- normal quit (`applicationWillTerminate`),
- user-initiated disable/pause,
- and, where feasible, unexpected termination via a signal/termination handler.
On next launch, MacMenu re-applies saved rules deliberately rather than assuming prior state.

## Options considered
- **Explicit restore on all exit paths (chosen)** — safest; treats the menu bar mutation as a side effect that must always be cleaned up.
- **Rely on the OS to reset on app exit** — unreliable for the spacer technique; rejected.
- **Persist "hidden" state and re-hide silently on next launch** — risks compounding a broken state; instead we restore, then re-apply rules.

## Consequences
- The manipulator's lifecycle is built around guaranteed cleanup.
- Crash-path restore is best-effort (signal handlers have limits) and is verified manually in the spike (force-quit test).
- Slightly more startup work (restore → reapply), accepted for safety.
