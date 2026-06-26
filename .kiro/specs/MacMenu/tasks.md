# MacMenu — Implementation Plan

Tasks are grouped by the phases in the design. Each phase ends with a runnable app and a written `report.md`. Documentation deliverables (ADRs, docs, prerequisites/learning guide) are explicit tasks. Scope C (search + global shortcuts) is intentionally not included — it is deferred to a future version.

---

## Phase 0 — Documentation scaffolding & learning baseline

- [ ] 0. Set up project + documentation skeleton
  - [ ] 0.1 Create the `MacMenu/` folder structure (App/Core/MenuBar/UI/Resources, MacMenuTests, docs/) as in the design
    - _Requirements: 9.2, 9.3_
  - [ ] 0.2 Write `docs/prerequisites-and-learning.md`: NSStatusItem/menu bar internals, Accessibility/AXUIElement, TCC permissions, AppKit run loop, and how to validate hide/show/restore on a given macOS version
    - _Requirements: 9.4, 9.5_
  - [ ] 0.3 Write the docs set: `overview.md`, `architecture.md`, `build-and-run.md`, `glossary.md`
    - _Requirements: 9.2_
  - [ ] 0.4 Write `docs/phases/phase-plan.md` and create per-phase `tasks.md`/`report.md` stubs
    - _Requirements: 9.3_
  - [ ] 0.5 Author initial ADRs 0001 (stack), 0002 (lifecycle/threading), 0006 (restore-on-exit guarantee)
    - _Requirements: 9.1, 8.2_

---

## Phase 1 — Spike & Foundation

- [ ] 1. Prove the technique and build the shell
  - [ ] 1.1 Create Swift app target; set `LSUIElement` to run without a Dock icon (configurable later)
    - _Requirements: 5.4_
  - [ ] 1.2 Install the MacMenu control `NSStatusItem`
    - _Requirements: 5.1_
  - [ ] 1.3 **Spike:** prototype the spacer/length-toggle hide-show on the owner's macOS version; confirm click-through and behavior near the notch
    - _Requirements: 2.1, 2.2, 2.4_
  - [ ] 1.4 Define core protocols/value types: `MenuBarManipulator`, `ManagedItem`, `Visibility`, `ItemGroup`, `MacMenuConfig`
    - _Requirements: 3.1, 4.1, 8.1_
  - [ ] 1.5 Write ADR 0003 (menu-bar management technique) documenting spike findings and the chosen approach
    - _Requirements: 9.1, 9.5_
  - [ ] 1.6 Write `phase-01` report
    - _Requirements: 9.3_

---

## Phase 2 — Hide/Show (Scope A)

- [ ] 2. Implement hide and reveal
  - [ ] 2.1 Implement `SpacerStrategy` conforming to `MenuBarManipulator` (expand/collapse spacer to hide/reveal)
    - _Requirements: 2.1, 2.2_
  - [ ] 2.2 Toggle hidden region from the MacMenu control; collapse on click-away/toggle
    - _Requirements: 2.3, 5.2_
  - [ ] 2.3 Optional auto-collapse after configurable idle timeout
    - _Requirements: 5.3_
  - [ ] 2.4 Implement `restoreAll()` and wire it to app exit/disable and a termination handler (never leave the bar broken)
    - _Requirements: 8.2_
  - [ ] 2.5 Mark unmanageable items and explain why
    - _Requirements: 2.5_
  - [ ] 2.6 Validate hide/reveal/restore against real menu bar icons; write `phase-02` report
    - _Requirements: 9.5, 9.3_

---

## Phase 3 — Visibility rules & persistence

- [ ] 3. Per-item rules and durable config
  - [ ] 3.1 Implement `ItemRegistry`: discover items + owning app metadata; react to add/remove
    - _Requirements: 1.1, 1.2, 1.3_
  - [ ] 3.2 Handle missing inspection permission without crashing; explain what's unavailable
    - _Requirements: 1.4, 6.2_
  - [ ] 3.3 Implement pure `VisibilityRuleEngine` (always-visible / hidden / always-hidden) with unit tests
    - _Requirements: 3.1, 3.3_
  - [ ] 3.4 Implement `ConfigStore` persistence; apply each item's last rule on launch; round-trip unit tests
    - _Requirements: 3.2, 7.3_
  - [ ] 3.5 Isolate failures when an inspected app quits/hangs/returns bad data
    - _Requirements: 8.1_
  - [ ] 3.6 Write `phase-03` report
    - _Requirements: 9.3_

---

## Phase 4 — Grouping & ordering (Scope B)

- [ ] 4. Organize items
  - [ ] 4.1 Implement pure `GroupingModel`: assign items to user-defined groups; unit tests
    - _Requirements: 4.1_
  - [ ] 4.2 Implement reordering within the managed region; persist order; reorder-stability unit tests
    - _Requirements: 4.2, 4.3_
  - [ ] 4.3 Render revealed/hidden items in configured group and order; document native-position limitation
    - _Requirements: 4.3, 4.4_
  - [ ] 4.4 Write `phase-04` report
    - _Requirements: 9.3_

---

## Phase 5 — Polish, preferences & resilience

- [ ] 5. Finalize UX and robustness
  - [ ] 5.1 Preferences UI: set per-item visibility + group assignment
    - _Requirements: 7.1_
  - [ ] 5.2 Preferences: auto-collapse timeout and Dock-icon toggle; persist all prefs
    - _Requirements: 7.2, 7.3_
  - [ ] 5.3 Permission onboarding: detect/request Accessibility & Screen Recording with explanation + System Settings deep link; detect unsupported macOS behavior
    - _Requirements: 6.1, 6.2, 6.3_
  - [ ] 5.4 Launch at login via `SMAppService`
    - _Requirements: 7.4_
  - [ ] 5.5 Handle display/resolution/notch changes by re-evaluating and reapplying layout
    - _Requirements: 8.4_
  - [ ] 5.6 Ensure UI inspection/manipulation stays off the main thread where possible
    - _Requirements: 8.3_
  - [ ] 5.7 Finalize all docs/ADRs; write `phase-05` report and project README
    - _Requirements: 9.1, 9.2, 9.3_
