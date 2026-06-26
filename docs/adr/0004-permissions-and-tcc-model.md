# ADR 0004 — Permissions and TCC model

**Status:** Accepted

## Context
Some capabilities require sensitive permissions gated by TCC: **Accessibility** (inspect/position other apps' UI) and possibly **Screen Recording** (read menu bar pixels). The baseline spacer hide/show needs none. Users must understand and control what they grant (Requirement 6).

## Decision
Request **only what a feature needs, when it's needed**, with a clear explanation and a deep link to System Settings > Privacy & Security. If a permission is denied, **disable only the affected feature** and explain the impact; never crash or silently fail. Detect, where possible, when the underlying technique behaves differently on the running macOS version and inform the user.

## Options considered
- **Least-privilege, feature-gated requests (chosen)** — respectful, resilient, matches Apple's guidance.
- **Request everything up front** — poor UX, scares users, unnecessary for hide/show.
- **Assume permissions are granted** — leads to crashes/confusion when they aren't; rejected.

## Consequences
- Hide/show always works; enhancements light up as permissions are granted (Requirement 6.2).
- Clear onboarding UI needed (Phase 5).
- Must handle the "granted then later revoked" transition gracefully.
- All inspected data stays on-device (Requirement 6.4).
