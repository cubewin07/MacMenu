// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MacMenu",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // The pure, OS-independent core. The menu bar app target (created in
        // Xcode during Phase 1) will depend on this library. All status-item
        // manipulation lives behind the MenuBarManipulator protocol, outside Core.
        .library(name: "MacMenuCore", targets: ["MacMenuCore"])
    ],
    targets: [
        .target(
            name: "MacMenuCore"
        ),
        .testTarget(
            name: "MacMenuCoreTests",
            dependencies: ["MacMenuCore"]
        )
    ]
)
