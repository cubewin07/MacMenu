import Foundation

/// A discovered menu bar item, as reported by the OS-manipulation layer.
public struct DiscoveredItem: Sendable, Equatable {
    public let id: String
    public let appName: String
    public let bundleId: String?
    public let isManageable: Bool

    public init(id: String, appName: String, bundleId: String? = nil, isManageable: Bool = true) {
        self.id = id
        self.appName = appName
        self.bundleId = bundleId
        self.isManageable = isManageable
    }
}

/// Whether the managed region is currently revealed or collapsed.
public enum HiddenRegionState: Sendable, Equatable {
    case collapsed
    case revealed
}

/// The single boundary to all OS-specific, version-fragile menu bar manipulation
/// (see ADR 0003). Concrete implementations (`SpacerStrategy`,
/// `AccessibilityStrategy`) live in the app's MenuBar layer, created in Phases
/// 1–2. Keeping this a protocol lets the pure Core be tested with a fake.
///
/// Implementations MUST guarantee `restoreAll()` returns the menu bar to a
/// normal state on exit/disable (ADR 0006, Requirement 8.2).
public protocol MenuBarManipulator: AnyObject, Sendable {
    /// Discover the status items currently in the menu bar.
    func discoverItems() throws -> [DiscoveredItem]

    /// Reveal or collapse the hidden region.
    func setRegion(_ state: HiddenRegionState) throws

    /// Restore other apps' items to their normal visible state. Called on
    /// quit/disable and, where feasible, on unexpected termination.
    func restoreAll() throws
}

/// Errors the manipulator layer can surface.
public enum MenuBarError: Error, Equatable, Sendable {
    /// The technique is unsupported on this macOS version (see ADR 0003).
    case unsupportedOnThisOS(String)
    /// A required permission (Accessibility/Screen Recording) is not granted.
    case missingPermission(String)
    /// The item could not be managed (e.g., another app's protected item).
    case itemNotManageable(String)
}
