# Phase 4 — Grouping & Ordering (Scope B)

**Goal:** Organize managed items into groups and reorder them, persisted within the managed region.

**Maps to Kiro spec task:** 4 (sub-tasks 4.1–4.4)

## Tasks
- [ ] Pure `GroupingModel`: assign items to user-defined groups; unit tests.
- [ ] Reordering within the managed region; persist order; reorder-stability unit tests.
- [ ] Render revealed/hidden items in configured group and order; document native-position limitation.
- [ ] Write `report.md`.

## Learning focus
- Stable ordering models and how they map to the rendered region.
- The boundary between what the spacer technique can and cannot reorder (native slots).

## Validation
- Create groups, assign items, reorder; restart; confirm persistence.
- Confirm documented limitation: ordering applies within MacMenu's region, not other apps' native slots.

## Exit criteria
- Grouping/ordering persists; limitation documented; grouping unit tests pass.
