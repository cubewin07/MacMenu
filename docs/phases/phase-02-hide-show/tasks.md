# Phase 2 — Hide/Show (Scope A)

**Goal:** A reliable hide/reveal experience with the restore-on-exit guarantee.

**Maps to Kiro spec task:** 2 (sub-tasks 2.1–2.6)

## Tasks
- [ ] Implement `SpacerStrategy` conforming to `MenuBarManipulator` (expand/collapse spacer).
- [ ] Toggle hidden region from the MacMenu control; collapse on click-away/toggle.
- [ ] Optional auto-collapse after a configurable idle timeout.
- [ ] Implement `restoreAll()`; wire to quit/disable and a termination handler (ADR 0006).
- [ ] Mark unmanageable items and explain why.
- [ ] Validate hide/reveal/restore on real icons; write `report.md`.

## Learning focus
- Status item length manipulation in practice; reveal/collapse timing.
- Lifecycle hooks for guaranteed restore (`applicationWillTerminate`, signal handling limits).

## Validation
- Hide several icons, reveal via the control, auto-collapse after timeout.
- Force-quit and confirm restore.
- Confirm click-through still works while hidden.

## Exit criteria
- Reliable hide/reveal; restore verified on all exit paths; unmanageable items handled.
