# MacMenu — Architecture (narrated)

Teaching-oriented narration of the canonical design in `.kiro/specs/MacMenu/design.md`.

## The one big idea: quarantine the fragile layer

The only genuinely risky, version-fragile, permission-dependent code is the code that manipulates *other apps'* menu bar items. We isolate all of it behind a single protocol, `MenuBarManipulator`. Everything else — visibility rules, grouping/ordering, persistence, UI — works on plain value types and is unit-testable without touching the OS. If a future macOS breaks the technique, only the manipulator implementation changes.

```
macOS menu bar (other apps' NSStatusItems)
        │   (spacer/length-toggle; optional Accessibility / Screen Recording)
        ▼
MenuBarManipulator (protocol)  ── SpacerStrategy  |  AccessibilityStrategy (optional)
        │
        ▼
Domain Core (PURE) ── ItemRegistry, VisibilityRuleEngine, GroupingModel, ConfigStore
        │
        ▼
Presentation ── MacMenuController (NSStatusItem), Preferences, Permission onboarding
```

## How hide/show actually works (spacer strategy)

MacMenu installs two of its own status items:
- A **control item** (always visible) — the thing you click.
- An **expandable spacer** whose width decides whether managed icons are pushed off the visible part of the bar.

- **Hidden:** spacer is wide → other icons are pushed left of the control / off-screen.
- **Revealed:** spacer collapses → icons slide into view. An optional idle timer re-hides them.

Because the other apps' items remain real, app-owned `NSStatusItem`s, clicking them still triggers their normal behavior — MacMenu only influences *visibility/position*, not ownership.

**Honest limitation:** precise reordering of another app's *native* slot isn't guaranteed by this technique. Ordering is therefore applied within MacMenu's own managed/rendered region, and this is documented (Requirement 4.4, ADR 0003).

## Components

| Component | Responsibility | Pure/testable? |
|-----------|----------------|----------------|
| `MenuBarManipulator` (protocol) | hide/reveal/position + `restoreAll()` | No (device) |
| `SpacerStrategy` | spacer/length-toggle implementation | No |
| `AccessibilityStrategy` (optional) | identify/position via AXUIElement | No |
| `ItemRegistry` | track discovered items + owning app metadata | Partial |
| `VisibilityRuleEngine` | decide visible/hidden/always-hidden per item | **Yes** |
| `GroupingModel` | groups + ordering within managed region | **Yes** |
| `ConfigStore` | persist rules/groups/prefs | **Yes** |
| `MacMenuController` | own control item, toggle region, auto-collapse | Partial |
| `PermissionCoordinator` | detect/request permissions, degrade gracefully | Partial |

## The restore guarantee (most important behavior)

If MacMenu ever leaves the menu bar in a broken state, it's worse than useless. So:
- `restoreAll()` resets spacer widths so other items return to normal.
- It runs on normal quit, on disable, and via a termination/signal handler for unexpected exits where feasible (Requirement 8.2).
- This is enshrined in ADR 0006.

## Threading
- UI inspection runs off the main thread where the API allows; all `NSStatusItem` mutations are marshalled back to the main thread (AppKit requirement).
- Per-app inspection is wrapped so a hung or quit app is isolated and doesn't stall MacMenu (Requirement 8.1).

## Permissions & degradation
- The spacer hide/show needs **no special permission** — it's the durable baseline.
- Accessibility/Screen Recording are **optional enhancements** for identification/grouping. If not granted, those features are disabled with clear messaging and a deep link to System Settings; hide/show still works (Requirements 6.1, 6.2).

## Reacting to layout changes
Display changes, resolution changes, and the **notch** alter the usable menu bar width. MacMenu listens for screen-change notifications and re-evaluates/reapplies its layout (Requirement 8.4).

## Where the learning concentrates
- **Phase 1 spike:** NSStatusItem internals, menu bar layout, and proving the technique on your macOS version. This is the make-or-break learning moment.
- **Phase 5:** TCC permissions and Accessibility APIs.

See `prerequisites-and-learning.md` for what to study and how to verify behavior.
