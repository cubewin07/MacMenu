# ADR 0003 — Menu bar management technique

**Status:** Proposed (to be confirmed by the Phase 1 spike)

## Context
This is the defining decision of the project. macOS offers **no public API** to hide, move, or reorder another app's `NSStatusItem`. The known approaches each have different power, permission cost, and fragility:
- **Spacer/length-toggle** — MacMenu resizes its own status items to push others on/off the visible bar. No special permission. Most durable historically. Limited reordering of native slots.
- **Accessibility (AXUIElement)** — inspect/position items; richer, but needs the Accessibility permission and is fragile across OS versions.
- **Screen Recording** — render other icons inside MacMenu's UI; heavy, privacy-sensitive permission.

## Decision (provisional)
Adopt a **pluggable `MenuBarManipulator`**. Ship the **spacer/length-toggle strategy** as the baseline for hide/show (no permission). Use **Accessibility only as an optional enhancement** for identification and grouping. Run a **spike in Phase 1** on the target Mac/macOS version to confirm exactly what works, then finalize this ADR with concrete findings.

## Options considered
- **Spacer baseline + optional Accessibility (chosen)** — lowest permission cost, most resilient, degrades gracefully.
- **Accessibility-first** — more capable but permission-gated and fragile; relegated to enhancement.
- **Screen Recording-based rendering** — powerful but invasive; avoided for v1.

## Consequences
- Hide/show works without permissions; grouping/identification may be limited without Accessibility (Requirement 4.4, 6.2).
- Precise reordering of native slots may be impossible; ordering applies within MacMenu's managed region — documented.
- The Phase 1 spike report (per macOS version) becomes essential living documentation.
- This ADR moves to **Accepted** with specifics after the spike; expect to revisit it after major macOS updates.
