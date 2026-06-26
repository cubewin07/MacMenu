# MacMenu — Master Phase Plan (the skeleton)

The whole-project skeleton. Each phase is a self-contained increment ending with a **runnable app** and a written **report**. The riskiest work (proving the technique works at all) is deliberately **first**, because if the spike fails, the whole approach must be reconsidered before more is built.

Each phase folder contains:
- `tasks.md` — concrete checklist (mirrors the Kiro spec tasks, with learning notes).
- `report.md` — written at the end: what was built, what was learned, how behavior was verified on the target macOS version.

## Phase map

| Phase | Theme | Key APIs | Risk | Exit criteria |
|-------|-------|----------|------|---------------|
| [0](phase-00-foundation-docs/tasks.md) | Docs & learning baseline | — | Low | Docs, ADRs, learning guide, phase skeleton exist |
| [1](phase-01-spike-and-foundation/tasks.md) | Spike & foundation | NSStatusItem, NSStatusBar | **High** | Technique proven on target macOS; control item runs; ADR 0003 finalized |
| [2](phase-02-hide-show/tasks.md) | Hide/Show (Scope A) | NSStatusItem length | Med | Reliable hide/reveal + restore-on-exit |
| [3](phase-03-rules-persistence/tasks.md) | Rules & persistence | AXUIElement, UserDefaults | Med | Per-item rules persist + reapply; discovery works |
| [4](phase-04-grouping-ordering/tasks.md) | Grouping & ordering (Scope B) | (pure logic) | Low–Med | Groups/order persist within managed region |
| [5](phase-05-polish-prefs/tasks.md) | Polish, prefs & resilience | SwiftUI, TCC, SMAppService, NSScreen | Med | Prefs/onboarding/launch-at-login; notch/display handling |

## Dependency flow

```
Phase 0 (docs) ──► Phase 1 (SPIKE — prove the technique)
                          │  (if spike fails, revisit ADR 0003 before continuing)
                          ▼
                   Phase 2 (Hide/Show + restore guarantee)
                          ▼
                   Phase 3 (Discovery, rules, persistence)
                          ▼
                   Phase 4 (Grouping & ordering)
                          ▼
                   Phase 5 (Polish, permissions, resilience)
```

Unlike iStats, MacMenu's phases are **strictly sequential** — each builds directly on the proven technique from Phase 1.

## Definition of Done (every phase)
1. Code compiles and the app runs.
2. New pure logic (rules, grouping, persistence) has passing unit tests.
3. Behavior is verified on the target macOS version per the spike checklist; results recorded in `report.md`.
4. The **restore-on-exit** guarantee still holds (re-verified each phase that touches the bar).
5. New decisions captured as/within an ADR; relevant docs updated.

## Special note on the spike (Phase 1)
The spike is go/no-go. If the spacer technique doesn't work acceptably on the target macOS version, document it in the Phase 1 report and reopen ADR 0003 (consider Accessibility-driven approach or revised scope) **before** investing in Phases 2+.

## How to use this with Kiro
The executable task list is `.kiro/specs/MacMenu/tasks.md`. These phase files are the richer companion; fill in each `report.md` as you complete a phase.
