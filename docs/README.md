# MacMenu Documentation

This folder is the human-readable home for everything about how MacMenu is designed, planned, and learned. It is intentionally separate from the Kiro spec (`.kiro/specs/MacMenu/`) so the planning is easy to browse and manage on its own.

## How this folder is organized

| Folder / file | Purpose |
|---------------|---------|
| `overview.md` | What MacMenu is, who it's for, goals/non-goals, and the central technical constraint. Start here. |
| `architecture.md` | The system design in prose + diagrams: layers, the fragile OS layer, data flow, threading. |
| `build-and-run.md` | How to build, run, and debug the app locally, including the permissions involved. |
| `glossary.md` | Definitions of every OS/macOS term used in the project. |
| `prerequisites-and-learning.md` | **The learning guide.** What to understand before each phase, and how to verify behavior on a given macOS version. |
| `adr/` | Architecture Decision Records — one file per significant decision. |
| `phases/` | The phased delivery plan. `phase-plan.md` is the master skeleton; each `phase-XX-*/` folder has its own `tasks.md` and `report.md`. |

## Read this first

MacMenu's core capability — managing *other apps'* menu bar items — has **no public macOS API**. The whole project is shaped around that constraint. Read `overview.md` and `adr/0003-menu-bar-management-technique.md` before anything else.

## Relationship to the Kiro spec

- `.kiro/specs/MacMenu/requirements.md` — formal requirements (EARS).
- `.kiro/specs/MacMenu/design.md` — canonical design; `architecture.md` here is the narrated, teaching-oriented version.
- `.kiro/specs/MacMenu/tasks.md` — the executable task list; `phases/` here is the richer human-facing breakdown with learning notes and per-phase reports.

## Suggested reading order for a newcomer
1. `overview.md`
2. `adr/0003-menu-bar-management-technique.md`
3. `prerequisites-and-learning.md`
4. `architecture.md`
5. `phases/phase-plan.md`
