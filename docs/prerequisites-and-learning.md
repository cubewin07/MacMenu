# MacMenu — Prerequisites & Learning Guide

The most important document for the learning goal. For each part of the app it answers:
1. What do I need to understand before writing or trusting this code?
2. How do I verify it behaves correctly on a given macOS version?

You come from a full-stack background and have not done OS-level macOS work. Notes bridge from concepts you know.

---

## Part 1 — Foundational concepts (study before the Phase 1 spike)

### The menu bar is not yours
Other apps own their `NSStatusItem`s. There is **no public API** to move/hide/reorder them. Internalize this first — the whole design is a workaround. Analogy: you're trying to rearrange DOM nodes you didn't render and can't directly select; you can only insert your own nodes and resize them.

### NSStatusItem / NSStatusBar
- `NSStatusBar.system` hosts status items; `statusItem(withLength:)` creates yours.
- A status item's **length** is the lever the spacer trick pulls.
- Study: `NSStatusItem`, `NSStatusBarButton`, variable vs fixed length.

### AppKit app lifecycle & run loop
- Menu bar apps set `LSUIElement` to run without a Dock icon/window.
- The run loop and notifications (`NSApplication`, screen-change notifications) drive re-layout.
- Study: `NSApplicationDelegate`, the main run loop, `NotificationCenter`.

### The notch and multi-display
- Modern MacBooks have a camera notch that consumes menu bar width; external displays change available width.
- Study: `NSScreen`, `safeAreaInsets`, screen-change notifications.

### Accessibility (AXUIElement) and TCC
- The **Accessibility API** lets an app inspect/interact with other apps' UI — gated by the **Accessibility** permission (TCC).
- **Screen Recording** is a separate, heavier permission needed to read menu bar pixels.
- Study: `AXUIElementCopyAttributeValue`, `AXIsProcessTrusted`, how to deep-link to System Settings > Privacy.

### Threading
- All `NSStatusItem` mutations must happen on the **main thread**. Inspection can be backgrounded.
- Study: GCD / Swift concurrency, `@MainActor`.

---

## Part 2 — The spike (Phase 1) is the key experiment

Before committing to the design, prove on YOUR Mac and macOS version:
1. Can you create a control item and an adjustable spacer?
2. Does widening the spacer push neighboring icons off the visible bar?
3. Does collapsing it bring them back?
4. Do the other icons still respond to clicks (click-through preserved)?
5. Does behavior hold near the notch and on an external display?
6. On quit, can you reliably restore the original layout?

Record every answer in `phases/phase-01-spike-and-foundation/report.md` and finalize ADR 0003.

---

## Part 3 — How to validate behavior on a given macOS version

Because the technique is unofficial, "validation" means observed behavior, not an API contract:
1. Note your exact macOS version (`sw_vers`).
2. Run the spike checklist above; capture screenshots/video.
3. Test edge cases: many icons, very few icons, notch present/absent, multiple displays, dark/light mode.
4. Test the restore path: force-quit MacMenu and confirm the bar returns to normal.
5. Re-run this checklist after each macOS update; record results per version in the phase reports. A regression after an OS update is expected at some point — the docs should make that visible.

---

## Part 4 — Per-capability learning + verification

### Discovering items (Phase 3)
- **Learn:** Accessibility tree of the system menu bar; mapping items to bundle IDs.
- **Verify:** the discovered list matches what you see; launching/quitting an app updates it.
- **Gotcha:** without Accessibility permission, discovery is limited — the app must say so, not crash.

### Hide/Show (Phase 2)
- **Learn:** spacer length manipulation; reveal/collapse timing.
- **Verify:** spike checklist; click-through preserved; restore works.

### Rules & persistence (Phase 3)
- **Learn:** `UserDefaults`/Codable JSON; applying saved rules at launch.
- **Verify:** set rules, restart, confirm they persist and reapply.

### Grouping & ordering (Phase 4)
- **Learn:** stable ordering models; how ordering maps to the rendered region.
- **Verify:** reorder, restart, confirm order persists within the managed region.

### Permissions (Phase 5)
- **Learn:** TCC prompts, `AXIsProcessTrusted`, deep links to System Settings.
- **Verify:** deny permission → feature disabled with clear message; grant → feature enables.

---

## Part 5 — Recommended reading
- Apple docs: `NSStatusBar`, `NSStatusItem`, `NSApplication`, `NSScreen`, `SMAppService`.
- Apple docs: Accessibility (`AXUIElement`), App Sandbox & TCC basics.
- `man sw_vers` and general AppKit lifecycle references.
- Study how open-source menu bar managers structure their hide/show (for concepts, mindful of licensing).
