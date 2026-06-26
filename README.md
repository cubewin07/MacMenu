# MacMenu

A native macOS menu bar manager inspired by Bartender. Hide, show, group, and reorder other apps' menu bar icons. Built with Swift + AppKit/SwiftUI. This is a learning project for understanding macOS at the OS level.

## v1 scope

- **Hide/show** menu bar items behind a single control.
- **Grouping and reordering** of managed items.

Search and global keyboard shortcuts are deferred to a later version.

## Important constraint

macOS has no public API to manage another app's menu bar items. MacMenu uses a spacer/length-toggle technique (and optional Accessibility APIs) — fragile across macOS versions and dependent on user-granted permissions. The first phase is a spike to confirm what works on the target macOS version. See `.kiro/specs/MacMenu/design.md` and ADR 0003.

## Status

Planning complete. The spec lives in `.kiro/specs/MacMenu/`:
- `requirements.md` — what the app must do (EARS format)
- `design.md` — architecture, the menu-bar management technique tradeoffs, threading, permissions, project skeleton, phased plan
- `tasks.md` — phased implementation plan

Project docs (ADRs, architecture, prerequisites/learning guide, per-phase reports) live under `docs/` and are produced as part of Phase 0.

## Repo

Remote: https://github.com/cubewin07/MacMenu.git
