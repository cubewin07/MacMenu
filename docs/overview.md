# MacMenu — Project Overview

## What it is

MacMenu is a native macOS menu bar manager inspired by Bartender. It lets you hide, reveal, group, and reorder the menu bar icons (status items) of other apps, so a cluttered menu bar becomes tidy and organized.

## Who it's for

The primary user is the developer building it, who wants a clean menu bar and — more importantly — wants to learn macOS at the OS level. The author is an experienced full-stack developer (Spring Boot, React, system design) with no prior native macOS experience.

## v1 scope

- **Hide/Show (Scope A):** collapse other apps' icons behind one control and reveal them on demand.
- **Grouping & Reordering (Scope B):** organize managed items into groups and reorder them.

## Deferred (future versions)

- **Search & global keyboard shortcuts (Scope C).**
- Triggers/automation (auto-reveal on events), profiles, and advanced theming.

## The central technical constraint (read this carefully)

macOS provides **no public, supported API** for one app to move, hide, or reorder *another* app's menu bar item (`NSStatusItem`). Bartender-style apps achieve the effect with unofficial techniques:

- A **spacer/length-toggle trick**: MacMenu places its own status items and changes their width to push other icons on/off the visible area.
- Optionally the **Accessibility (AXUIElement) API** to identify/position items (requires the Accessibility permission).
- Optionally **Screen Recording** to render other icons inside MacMenu's own UI (heavy, privacy-sensitive permission).

These techniques are **fragile across macOS versions** and depend on user-granted permissions. Therefore:

1. The project's first real phase is a **spike** to confirm what works on the target macOS version.
2. The app must always **degrade gracefully** and must **restore the menu bar to normal on exit** — never leave the user's bar broken.
3. The docs must be **honest** about what is and isn't supported on each macOS version.

## Goals

1. A reliable hide/show experience using the least-invasive technique that works.
2. A hard guarantee that the menu bar is restored when MacMenu quits or is disabled.
3. Graceful handling of permissions and version differences.
4. Understandable, isolated OS-manipulation code so the author can explain and maintain it.
5. Incremental delivery with a runnable app and a written report each phase.

## Non-goals (v1)
- Managing items via any private/unsupported API that risks system stability beyond the documented spacer/Accessibility approach.
- App Store distribution (the techniques and permissions make this impractical for v1).

## Mental model (from a web background)
Think of the menu bar as a horizontal layout you don't own. You can't directly reparent or reorder someone else's element. What you *can* do is insert your own elements and resize them to influence what's visible — like using a flex spacer to push siblings out of the viewport. Identifying which icon belongs to which app is a separate, permissioned "inspect the DOM of the system" step (Accessibility). The restore guarantee is like always cleaning up a global side effect you introduced.

## Success criteria
- Hide/reveal/restore works reliably on the target macOS version (recorded in the Phase 1 spike report).
- Per-item visibility rules and grouping/ordering persist across launches.
- Missing permissions or unsupported OS behavior produce clear messaging, not crashes.
- Docs, ADRs, and phase reports are complete enough for another developer to continue.
