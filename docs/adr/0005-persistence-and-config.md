# ADR 0005 — Persistence and config format

**Status:** Accepted

## Context
MacMenu must remember per-item visibility rules, group assignments, ordering, and preferences (auto-collapse timeout, Dock-icon toggle, launch-at-login) across launches (Requirements 3.2, 7.3). Items are identified across launches by a stable key.

## Decision
Persist a single `MacMenuConfig` (Codable) via **`UserDefaults`** (or a JSON file in Application Support if the config grows). Identify items by a **stable key** derived from bundle identifier plus a slot heuristic. Apply saved rules at launch; write on change.

## Options considered
- **UserDefaults + Codable (chosen)** — simplest, robust for small structured config; easy to test via round-trip encode/decode.
- **JSON file in Application Support** — fine if config grows or needs to be inspectable; can migrate to this later.
- **A database (SQLite/Core Data)** — overkill for this volume; rejected.

## Consequences
- Round-trip encode/decode is unit-tested in `Core` (no OS needed).
- Item identity depends on bundle id stability; items that can't be stably identified get a best-effort key and may reset — documented behavior.
- A future format change needs a small migration step (note it in a new ADR if it happens).
