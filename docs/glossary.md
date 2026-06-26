# MacMenu — Glossary

Plain-language definitions for a developer new to OS-level macOS work.

| Term | Definition |
|------|------------|
| **AppKit** | Apple's macOS UI framework; used for the menu bar control. |
| **SwiftUI** | Apple's declarative UI framework; used for preferences. |
| **NSStatusItem** | An app's icon/text in the menu bar. Other apps own theirs; MacMenu owns its control + spacer. |
| **NSStatusBar** | The system menu bar that hosts status items. |
| **NSStatusBarButton** | The clickable button backing a status item. |
| **Status item length** | The width of a status item; the lever the spacer trick adjusts to hide/reveal others. |
| **LSUIElement** | Info.plist flag to run without a Dock icon/window — typical for menu bar apps. |
| **Menu bar extra** | Apple's term for a status item. |
| **Spacer / length-toggle trick** | Using a resizable status item to push other icons on/off the visible bar. |
| **Click-through** | Other apps' items still respond to clicks because MacMenu doesn't take ownership, only influences visibility. |
| **Accessibility API (AXUIElement)** | macOS API to inspect/interact with other apps' UI; needs the Accessibility permission. |
| **AXIsProcessTrusted** | Check whether the app has been granted Accessibility permission. |
| **Screen Recording permission** | TCC permission required to read screen/menu-bar pixels. |
| **TCC** | Transparency, Consent & Control — the system gating sensitive permissions. |
| **IORegistry / IOKit** | Device/driver registry and framework (not central to MacMenu, but referenced). |
| **NSScreen** | Represents a display; used to handle resolution/notch/multi-display changes. |
| **Notch** | The camera cutout on modern MacBooks that consumes menu bar width. |
| **Run loop** | The AppKit event loop that processes events and notifications. |
| **NotificationCenter** | Mechanism to observe system events like screen changes. |
| **@MainActor** | Swift concurrency annotation for code that must run on the main (UI) thread. |
| **SMAppService** | Modern API to register an app to launch at login. |
| **ManagedItem** | MacMenu's model of a tracked menu bar item (app, visibility, group, order). |
| **Visibility rule** | always-visible / hidden / always-hidden setting per item. |
| **MenuBarManipulator** | The protocol isolating all OS-manipulation code. |
| **restoreAll()** | The method that returns the menu bar to its normal state on exit/disable. |
| **ConfigStore** | Persists user preferences, rules, and groups. |
| **ADR** | Architecture Decision Record — a short document capturing one decision. |
