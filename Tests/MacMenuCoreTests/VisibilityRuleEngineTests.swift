import XCTest
@testable import MacMenuCore

final class VisibilityRuleEngineTests: XCTestCase {

    private func makeItems() -> [ManagedItem] {
        [
            ManagedItem(id: "a", appName: "A", visibility: .alwaysVisible, order: 0),
            ManagedItem(id: "b", appName: "B", visibility: .hidden, order: 1),
            ManagedItem(id: "c", appName: "C", visibility: .hidden, order: 2),
            ManagedItem(id: "d", appName: "D", visibility: .alwaysHidden, order: 3)
        ]
    }

    func testCollapsedShowsOnlyAlwaysVisible() {
        let visible = VisibilityRuleEngine.visibleItems(makeItems(), region: .collapsed)
        XCTAssertEqual(visible.map(\.id), ["a"])
    }

    func testRevealedShowsAlwaysVisibleAndHidden() {
        let visible = VisibilityRuleEngine.visibleItems(makeItems(), region: .revealed)
        XCTAssertEqual(Set(visible.map(\.id)), ["a", "b", "c"])
    }

    func testAlwaysHiddenNeverShown() {
        XCTAssertFalse(VisibilityRuleEngine.visibleItems(makeItems(), region: .collapsed).contains { $0.id == "d" })
        XCTAssertFalse(VisibilityRuleEngine.visibleItems(makeItems(), region: .revealed).contains { $0.id == "d" })
    }

    func testCategoryHelpers() {
        let items = makeItems()
        XCTAssertEqual(VisibilityRuleEngine.alwaysVisibleItems(items).map(\.id), ["a"])
        XCTAssertEqual(VisibilityRuleEngine.revealableItems(items).map(\.id), ["b", "c"])
        XCTAssertEqual(VisibilityRuleEngine.alwaysHiddenItems(items).map(\.id), ["d"])
    }
}
