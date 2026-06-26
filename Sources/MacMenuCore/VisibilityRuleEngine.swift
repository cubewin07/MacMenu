import Foundation

/// Pure logic that decides what is shown given the user's per-item rules and
/// whether the user has currently revealed the hidden region. No OS dependency,
/// fully unit-tested (Requirements 2, 3).
public enum VisibilityRuleEngine {

    /// Items that are always shown in the menu bar regardless of region state.
    public static func alwaysVisibleItems(_ items: [ManagedItem]) -> [ManagedItem] {
        items.filter { $0.visibility == .alwaysVisible }
    }

    /// Items that can be revealed (hidden, not always-hidden).
    public static func revealableItems(_ items: [ManagedItem]) -> [ManagedItem] {
        items.filter { $0.visibility == .hidden }
    }

    /// Items that are never shown.
    public static func alwaysHiddenItems(_ items: [ManagedItem]) -> [ManagedItem] {
        items.filter { $0.visibility == .alwaysHidden }
    }

    /// The set of items that should be visible right now.
    ///
    /// - When collapsed: only `alwaysVisible` items show.
    /// - When revealed: `alwaysVisible` + `hidden` items show; `alwaysHidden` never shows.
    public static func visibleItems(_ items: [ManagedItem], region: HiddenRegionState) -> [ManagedItem] {
        switch region {
        case .collapsed:
            return alwaysVisibleItems(items)
        case .revealed:
            return items.filter { $0.visibility != .alwaysHidden }
        }
    }
}
