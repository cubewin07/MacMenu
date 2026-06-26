import Foundation

/// How a managed menu bar item should be treated.
public enum Visibility: String, Sendable, Equatable, Codable, CaseIterable {
    /// Always shown in the menu bar.
    case alwaysVisible
    /// Hidden but revealable via the MacMenu control.
    case hidden
    /// Never shown.
    case alwaysHidden
}

/// A menu bar item MacMenu tracks. Identified across launches by a stable `id`
/// (bundle id + slot heuristic — see ADR 0005).
public struct ManagedItem: Identifiable, Sendable, Equatable, Codable {
    public let id: String
    public var appName: String
    public var bundleId: String?
    public var visibility: Visibility
    public var groupId: UUID?
    public var order: Int

    public init(id: String, appName: String, bundleId: String? = nil,
                visibility: Visibility = .hidden, groupId: UUID? = nil, order: Int = 0) {
        self.id = id
        self.appName = appName
        self.bundleId = bundleId
        self.visibility = visibility
        self.groupId = groupId
        self.order = order
    }
}

/// A user-defined group of items.
public struct ItemGroup: Identifiable, Sendable, Equatable, Codable {
    public let id: UUID
    public var name: String
    public var order: Int

    public init(id: UUID = UUID(), name: String, order: Int = 0) {
        self.id = id
        self.name = name
        self.order = order
    }
}

/// The full persisted configuration (ADR 0005). Only preferences/layout are
/// persisted — never any inspected app data beyond what the user organizes.
public struct MacMenuConfig: Sendable, Equatable, Codable {
    public var items: [ManagedItem]
    public var groups: [ItemGroup]
    public var autoCollapseSeconds: Int?
    public var showDockIcon: Bool
    public var launchAtLogin: Bool

    public init(items: [ManagedItem] = [], groups: [ItemGroup] = [],
                autoCollapseSeconds: Int? = nil, showDockIcon: Bool = false,
                launchAtLogin: Bool = false) {
        self.items = items
        self.groups = groups
        self.autoCollapseSeconds = autoCollapseSeconds
        self.showDockIcon = showDockIcon
        self.launchAtLogin = launchAtLogin
    }

    public static let empty = MacMenuConfig()
}
