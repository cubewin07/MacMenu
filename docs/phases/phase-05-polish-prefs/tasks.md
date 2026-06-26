# Phase 5 — Polish, Preferences & Resilience

**Goal:** Finish the preferences UI, permission onboarding, launch-at-login, and display/notch resilience.

**Maps to Kiro spec task:** 5 (sub-tasks 5.1–5.7)

## Tasks
- [ ] Preferences UI: set per-item visibility + group assignment.
- [ ] Preferences: auto-collapse timeout and Dock-icon toggle; persist all prefs.
- [ ] Permission onboarding: detect/request Accessibility & Screen Recording with explanation + System Settings deep link; detect unsupported macOS behavior.
- [ ] Launch at login via `SMAppService`.
- [ ] Handle display/resolution/notch changes by re-evaluating and reapplying layout.
- [ ] Ensure UI inspection/manipulation stays off the main thread where possible.
- [ ] Finalize all docs/ADRs; write `report.md` and project README.

## Learning focus
- TCC prompts, `AXIsProcessTrusted`, deep links to System Settings.
- `SMAppService` login items.
- `NSScreen` / screen-change notifications and notch handling.

## Validation
- Deny/grant permissions and observe correct enable/disable + messaging.
- Change each preference, restart, confirm persisted.
- Change display/resolution; confirm layout re-applies; verify near the notch.

## Exit criteria
- All v1 requirements met; permissions handled gracefully; layout resilient; docs/ADRs/reports complete.
