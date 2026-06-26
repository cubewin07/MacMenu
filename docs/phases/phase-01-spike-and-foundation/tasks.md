# Phase 1 — Spike & Foundation (HIGH RISK / go-no-go)

**Goal:** Prove the hide/show technique works on the target Mac and macOS version, and stand up the app shell. This phase decides whether the whole approach is viable.

**Maps to Kiro spec task:** 1 (sub-tasks 1.1–1.6)

## Tasks
- [ ] Create the Xcode app target; set `LSUIElement` (no Dock icon).
- [ ] Install the MacMenu control `NSStatusItem`.
- [ ] **Spike:** prototype the spacer/length-toggle hide/show; run the full spike checklist below.
- [ ] Define core protocols/value types: `MenuBarManipulator`, `ManagedItem`, `Visibility`, `ItemGroup`, `MacMenuConfig`.
- [ ] Finalize **ADR 0003** with concrete findings (what worked, what didn't, on which macOS version).
- [ ] Write this phase's `report.md`.

## Spike checklist (record each answer in report.md)
1. Create control item + adjustable spacer? (yes/no)
2. Widening spacer pushes neighbor icons off the visible bar? (yes/no)
3. Collapsing spacer brings them back? (yes/no)
4. Other icons still respond to clicks (click-through)? (yes/no)
5. Behavior holds near the notch? (yes/no)
6. Behavior holds on an external display / different resolution? (yes/no)
7. On quit AND on force-quit, can the bar be restored to normal? (yes/no)

## Learning focus
- `NSStatusBar`/`NSStatusItem`, status item length as the control lever.
- AppKit lifecycle, `LSUIElement`, the run loop.
- `sw_vers` to pin the macOS version under test.

## Exit criteria (go/no-go)
- If the checklist mostly passes → proceed to Phase 2 and mark ADR 0003 Accepted.
- If it fails → document why in report.md, reopen ADR 0003, and reconsider approach/scope before building further.
