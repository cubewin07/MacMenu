# MacMenu — Requirements

## Introduction

MacMenu is a native macOS menu bar manager inspired by Bartender. It lets the user hide, show, group, and reorder the status items (menu bar icons) of other applications, reclaiming menu bar space and bringing order to a cluttered bar.

This is a learning project. The owner is an experienced full-stack developer (Spring Boot, React, some system design) with **no prior OS-level or native macOS experience**. The system must be understandable and thoroughly documented: Architecture Decision Records (ADRs), general docs, a phased delivery plan with per-phase reports and tasks, and a dedicated prerequisites/"what I need to learn" guide are first-class deliverables alongside the code.

**Tech stack:** Swift + SwiftUI/AppKit, native macOS. Target hardware is an Apple Silicon MacBook.

**v1 scope (confirmed with owner):**
- **A — Hide/show menu bar items:** collapse other apps' menu bar icons behind a single MacMenu control and reveal them on demand.
- **B — Custom menu bar with grouping/reordering:** organize hidden/visible items into groups and let the user reorder them.

**Deferred to a later version (out of scope for v1):**
- **C — Search and global keyboard shortcuts** for items.
- Triggers/automation (auto-show on system events), profiles, and appearance theming beyond the basics.

> **Critical technical constraint (must be acknowledged early):** macOS does **not** provide a public, supported API for one app to move, hide, or reorder *another* app's `NSStatusItem`. Bartender-style apps achieve this with techniques such as Accessibility APIs, Screen Recording permission, and careful manipulation of the menu bar, which are fragile across macOS versions and require user-granted permissions. v1 must establish exactly which approach is viable on the target macOS version. This is the central design risk and is captured explicitly in the requirements and an ADR.

---

## Glossary

- **Status item** — An icon another app places in the menu bar (`NSStatusItem`).
- **Menu bar extra** — Apple's term for a status item.
- **MacMenu control** — MacMenu's own status item that toggles the hidden region.
- **Hidden region** — The portion of the menu bar where managed items are collapsed out of view.
- **Accessibility (AX) API** — macOS APIs (`AXUIElement`) used to inspect/interact with other apps' UI; requires the Accessibility permission.
- **TCC** — Apple's Transparency, Consent, and Control system that gates sensitive permissions.

---

## Requirements

### Requirement 1: Discover other apps' menu bar items

**User Story:** As a user, I want MacMenu to detect the icons currently in my menu bar, so that it can manage them.

#### Acceptance Criteria

1. WHEN MacMenu launches with required permissions granted THEN MacMenu SHALL enumerate the status items currently present in the menu bar.
2. WHEN a status item appears or disappears (an app launches/quits) THEN MacMenu SHALL update its list of managed items.
3. WHERE an item can be identified, MacMenu SHALL associate it with its owning application (name/bundle identifier and icon).
4. IF the required permission to inspect the menu bar is not granted THEN MacMenu SHALL NOT crash and SHALL clearly explain what is unavailable and why.

### Requirement 2: Hide and show menu bar items (Scope A)

**User Story:** As a user, I want to collapse menu bar icons behind one control, so that my menu bar is tidy and I can reveal icons only when needed.

#### Acceptance Criteria

1. WHEN the user designates an item as "hidden" THEN MacMenu SHALL remove that item from the always-visible area of the menu bar.
2. WHEN the user activates the MacMenu control THEN MacMenu SHALL reveal the hidden items for interaction.
3. WHEN the user dismisses the hidden region (clicks away, toggles again, or after an optional timeout) THEN MacMenu SHALL collapse the hidden items again.
4. WHILE an item is hidden THEN MacMenu SHALL preserve the user's ability to click that item to trigger its owning app's normal behavior.
5. WHERE an item cannot be hidden due to platform limitations THEN MacMenu SHALL mark it as unmanageable and explain why.

### Requirement 3: Categorize items as always-visible, hidden, or always-hidden

**User Story:** As a user, I want per-item visibility rules, so that some icons always show, some collapse, and some never show.

#### Acceptance Criteria

1. WHERE the user configures it, MacMenu SHALL let each managed item be set to one of: always visible, hidden (revealable), or always hidden.
2. WHEN MacMenu starts THEN MacMenu SHALL apply each item's last configured visibility rule.
3. WHEN the user changes an item's rule THEN MacMenu SHALL apply the change immediately.

### Requirement 4: Group and reorder items (Scope B)

**User Story:** As a user, I want to group and reorder menu bar items, so that related icons are organized the way I want.

#### Acceptance Criteria

1. WHERE the user configures it, MacMenu SHALL allow items to be assigned to user-defined groups.
2. WHEN the user reorders items within the managed area THEN MacMenu SHALL apply and persist the new order to the extent the platform allows.
3. WHEN displaying revealed/hidden items THEN MacMenu SHALL present them in the configured group and order.
4. WHERE the platform does not permit reordering another app's native item position THEN MacMenu SHALL document the limitation and apply ordering only within MacMenu's own managed/rendered region.

### Requirement 5: MacMenu control and interaction model

**User Story:** As a user, I want a clear control in the menu bar, so that I can toggle and access managed items easily.

#### Acceptance Criteria

1. WHEN MacMenu launches THEN MacMenu SHALL install its own status item (the MacMenu control).
2. WHEN the user clicks the MacMenu control THEN MacMenu SHALL toggle visibility of the hidden region.
3. WHERE the user enables it, MacMenu SHALL support an optional auto-collapse after a configurable idle timeout.
4. WHEN running as a menu bar app THEN MacMenu SHALL be able to run without a Dock icon (configurable).

### Requirement 6: Permissions and platform constraints

**User Story:** As a user, I want clear, honest handling of the permissions MacMenu needs, so that I understand the tradeoffs and the app behaves predictably.

#### Acceptance Criteria

1. WHEN MacMenu requires a sensitive permission (e.g., Accessibility and/or Screen Recording, as determined during design) THEN MacMenu SHALL request it with a clear explanation and link to System Settings.
2. IF a required permission is denied THEN MacMenu SHALL degrade gracefully, disable the affected capability, and explain the impact rather than failing silently or crashing.
3. WHEN the menu-bar management technique is unsupported or behaves differently on the running macOS version THEN MacMenu SHALL detect this where possible and inform the user.
4. WHEN handling other apps' UI information THEN MacMenu SHALL keep all data local and SHALL NOT transmit it off the machine.

### Requirement 7: Configuration and preferences

**User Story:** As a user, I want to configure MacMenu's behavior, so that it fits my workflow.

#### Acceptance Criteria

1. WHERE the user opens preferences, MacMenu SHALL allow setting each item's visibility rule and group assignment.
2. WHERE the user opens preferences, MacMenu SHALL allow configuring the auto-collapse timeout and the Dock-icon toggle.
3. WHEN preferences change THEN MacMenu SHALL persist them across launches.
4. WHERE the user enables it, MacMenu SHALL support launch at login.

### Requirement 8: Stability and resilience

**User Story:** As a user, I want MacMenu to be stable, so that managing the menu bar never destabilizes my system or loses my layout.

#### Acceptance Criteria

1. IF an inspected app quits, hangs, or returns unexpected data THEN MacMenu SHALL isolate the failure and continue managing other items.
2. WHEN MacMenu exits or is disabled THEN MacMenu SHALL restore other apps' menu bar items to their normal visible state.
3. WHEN MacMenu performs UI inspection or manipulation THEN MacMenu SHALL do so off the main thread where possible and avoid blocking the UI.
4. WHEN the menu bar layout changes (display change, resolution change, notch) THEN MacMenu SHALL re-evaluate and reapply its layout.

### Requirement 9: Learning and documentation deliverables

**User Story:** As a developer learning OS-level macOS development, I want the project to teach me as it's built, so that I can understand, validate, and extend the code with confidence.

#### Acceptance Criteria

1. WHEN the project is planned THEN MacMenu SHALL include Architecture Decision Records (ADRs) capturing key technical choices (the menu-bar management technique, permissions model, persistence, threading).
2. WHEN the project is planned THEN MacMenu SHALL include a general documentation set (overview, architecture, build/run, glossary).
3. WHEN the project is planned THEN MacMenu SHALL include a phased delivery plan with a skeleton for the whole project, AND each phase SHALL have its own report and task list.
4. WHEN the project is planned THEN MacMenu SHALL include a dedicated prerequisites/"what I need to learn" document covering relevant OS concepts and macOS frameworks (NSStatusItem/menu bar internals, Accessibility/AXUIElement APIs, TCC permissions, AppKit run loop) and how to validate behavior.
5. WHERE a capability depends on a fragile or version-specific technique THEN the documentation SHALL describe how to verify it works on a given macOS version.

---

## Non-Functional Requirements

- **Platform:** macOS (target current major version; note minimum supported version as an ADR). Primary target Apple Silicon. Must account for the menu bar notch on modern MacBooks.
- **Language/UI:** Swift, AppKit for menu bar/status item control with SwiftUI for preferences where practical.
- **Privacy:** All data stays on-device; no network transmission of inspected app data.
- **Reliability:** Must always be able to restore the menu bar to a normal state on exit. A failure inspecting one app must not crash MacMenu.
- **Honesty about limitations:** Because the core capability relies on unofficial techniques, the app and docs must be explicit about what is and isn't supported on each macOS version.
- **Testability:** Visibility-rule logic, grouping/ordering, and persistence must be unit-testable independently of the OS-manipulation layer.
