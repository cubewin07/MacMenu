# Phase 3 — Discovery, Rules & Persistence

**Goal:** Discover items, set per-item visibility rules, and persist them across launches.

**Maps to Kiro spec task:** 3 (sub-tasks 3.1–3.6)

## Tasks
- [ ] `ItemRegistry`: discover items + owning app metadata; react to add/remove.
- [ ] Handle missing inspection permission without crashing; explain what's unavailable.
- [ ] Pure `VisibilityRuleEngine` (always-visible / hidden / always-hidden) + unit tests.
- [ ] `ConfigStore` persistence (Codable/UserDefaults); apply each item's last rule on launch; round-trip unit tests.
- [ ] Isolate failures when an inspected app quits/hangs/returns bad data.
- [ ] Write `report.md`.

## Learning focus
- Accessibility (AXUIElement) basics for discovery; `AXIsProcessTrusted`.
- Codable persistence; stable item identity (bundle id + slot heuristic).
- Failure isolation patterns.

## Validation
- Discovered list matches the actual menu bar; launching/quitting an app updates it.
- Set rules, restart app, confirm they persist and reapply.
- Deny Accessibility → discovery limited, clear message, no crash.

## Exit criteria
- Rules persist/reapply; discovery works with permission and degrades without it; rule-engine tests pass.
