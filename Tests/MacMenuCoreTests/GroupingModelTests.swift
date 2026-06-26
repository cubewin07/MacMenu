import XCTest
@testable import MacMenuCore

final class GroupingModelTests: XCTestCase {

    private let groupA = UUID()
    private let groupB = UUID()

    private func makeItems() -> [ManagedItem] {
        [
            ManagedItem(id: "1", appName: "One", groupId: groupA, order: 1),
            ManagedItem(id: "2", appName: "Two", groupId: groupA, order: 0),
            ManagedItem(id: "3", appName: "Three", groupId: groupB, order: 0),
            ManagedItem(id: "4", appName: "Four", groupId: nil, order: 5)
        ]
    }

    func testItemsInGroupSortedByOrder() {
        let items = GroupingModel.items(in: groupA, from: makeItems())
        XCTAssertEqual(items.map(\.id), ["2", "1"]) // order 0 then 1
    }

    func testUngroupedItems() {
        XCTAssertEqual(GroupingModel.ungroupedItems(makeItems()).map(\.id), ["4"])
    }

    func testAssignToGroup() {
        let updated = GroupingModel.assign(itemId: "4", toGroup: groupB, in: makeItems())
        let inB = GroupingModel.items(in: groupB, from: updated).map(\.id)
        XCTAssertTrue(inB.contains("4"))
    }

    func testAssignToNilUngroups() {
        let updated = GroupingModel.assign(itemId: "1", toGroup: nil, in: makeItems())
        XCTAssertTrue(GroupingModel.ungroupedItems(updated).contains { $0.id == "1" })
    }

    func testReorderRewritesOrder() {
        let updated = GroupingModel.reorder(items: makeItems(), to: ["3", "1", "2"])
        let byId = Dictionary(uniqueKeysWithValues: updated.map { ($0.id, $0.order) })
        XCTAssertEqual(byId["3"], 0)
        XCTAssertEqual(byId["1"], 1)
        XCTAssertEqual(byId["2"], 2)
        // Item 4 not in the list -> order unchanged
        XCTAssertEqual(byId["4"], 5)
    }

    func testReorderIsIdempotent() {
        let once = GroupingModel.reorder(items: makeItems(), to: ["1", "2", "3", "4"])
        let twice = GroupingModel.reorder(items: once, to: ["1", "2", "3", "4"])
        XCTAssertEqual(once, twice)
    }

    func testSortedGroups() {
        let groups = [ItemGroup(name: "B", order: 1), ItemGroup(name: "A", order: 0)]
        XCTAssertEqual(GroupingModel.sortedGroups(groups).map(\.name), ["A", "B"])
    }
}
