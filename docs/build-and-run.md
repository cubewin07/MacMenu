# MacMenu — Build & Run

> The Xcode project is created in Phase 1. Until then this describes the intended setup; update specifics once the project exists.

## Prerequisites
- macOS (current major version recommended). Primary target: Apple Silicon.
- Xcode (latest stable) + Command Line Tools: `xcode-select --install`.
- No signing identity required for local dev.

## Current state (Phase 1 scaffold)

A Swift Package provides the pure `Core` layer and tests today:
- `Package.swift` — defines the `MacMenuCore` library + `MacMenuCoreTests`.
- `Sources/MacMenuCore/` — models (`ManagedItem`, `Visibility`, `ItemGroup`, `MacMenuConfig`), the `MenuBarManipulator` protocol (the OS-manipulation boundary), `VisibilityRuleEngine`, `GroupingModel`, `ConfigStore`.
- `Tests/MacMenuCoreTests/` — 15 passing unit tests.

The menu bar **app target** (with `Info.plist` + `LSUIElement`, and the concrete `SpacerStrategy` implementing `MenuBarManipulator`) is created in Xcode during Phase 1 and depends on `MacMenuCore`.

### ⚠️ Build scratch path (important on this machine)

This folder sits in a synced/locked location where SwiftPM's `.build/build.db`
(SQLite) hits "disk I/O error". Build/test with a scratch path outside the project:

```
swift test --scratch-path /tmp/macmenu-build
```

If you ever see `accessing build database ... disk I/O error`, this is the fix.
(`.build/` is gitignored either way.)

## Project layout
```
MacMenu/
├── MacMenu/           # app target source
│   ├── App/           # entry point, AppDelegate, MacMenuController
│   ├── Core/          # VisibilityRuleEngine, GroupingModel, ConfigStore, models (pure)
│   ├── MenuBar/       # MenuBarManipulator + Spacer/Accessibility strategies
│   ├── UI/            # preferences, permission onboarding
│   └── Resources/     # Info.plist, assets
└── MacMenuTests/      # unit tests for Core
```

## Build & run
1. Open the project in Xcode.
2. Select the `MacMenu` scheme.
3. Run (⌘R). MacMenu's control item appears in the menu bar (no Dock icon with `LSUIElement`).

CLI (once a scheme exists):
```
xcodebuild -scheme MacMenu -configuration Debug build
```

## Running tests
- Package tests (today): `swift test --scratch-path /tmp/macmenu-build`
- Xcode: ⌘U.
- CLI (once an app scheme exists): `xcodebuild test -scheme MacMenu -destination 'platform=macOS'`
- `Core` tests (rules, grouping, persistence) run without the OS-manipulation layer.

## Permissions during development
- The spacer hide/show needs no special permission.
- To exercise identification/grouping enhancements you may need to grant **Accessibility** (and possibly **Screen Recording**) in System Settings > Privacy & Security. Grant them to the built app (or Xcode while debugging).
- If permission is denied, the app must degrade gracefully (see ADR 0004).

## Debugging tips
- `sw_vers` to record the exact macOS version you're testing against.
- Test near the notch and on an external display.
- Always verify the **restore-on-exit** path: quit/force-quit and confirm the menu bar returns to normal.
- Use `os_log`/`Logger`; view in Console.app.
