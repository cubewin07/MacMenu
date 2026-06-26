import Foundation

/// Pure logic for grouping and ordering managed items within MacMenu's region
/// (Requirement 4). Ordering applies to MacMenu's rendered region, not other
/// apps' native slots (documented limitation, ADR 0003). No OS dependency.
public enum GroupingModel {

    /// Items belonging to a given group, sorted by their `order`.
    public static func items(in groupId: UUID, from items: [ManagedItem]) -> [ManagedItem] {
        items.filter { $0.groupId == groupId }.sorted { $0.order < $1.order }
    }

    /// Items that aren't assigned to any group, sorted by `order`.
    public static func ungroupedItems(_ items: [ManagedItem]) -> [ManagedItem] {
        items.filter { $0.groupId == nil }.sorted { $0.order < $1.order }
    }

    /// Assign an item to a group (or `nil` to ungroup). Returns a new array.
    public static func assign(itemId: String, toGroup groupId: UUID?, in items: [ManagedItem]) -> [ManagedItem] {
        items.map { item in
            guard item.id == itemId else { return item }
            var copy = item
            copy.groupId = groupId
            return copy
        }
    }

    /// Reorder items by the given ordered list of ids, rewriting their `order`
    /// to match. Ids not present are left untouched (and keep their relative
    /// order after the reordered ones). Stable and idempotent.
    public static func reorder(items: [ManagedItem], to orderedIds: [String]) -> [ManagedItem] {
        let indexOf: [String: Int] = Dictionary(
            uniqueKeysWithValues: orderedIds.enumerated().map { ($0.element, $0.offset) }
        )
        return items.map { item in
            guard let newOrder = indexOf[item.id] else { return item }
            var copy = item
            copy.order = newOrder
            return copy
        }
    }

    /// Groups sorted by their `order`.
    public static func sortedGroups(_ groups: [ItemGroup]) -> [ItemGroup] {
        groups.sorted { $0.order < $1.order }
    }
}
