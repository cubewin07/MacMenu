import XCTest
@testable import MacMenuCore

final class ConfigStoreTests: XCTestCase {

    private func sampleConfig() -> MacMenuConfig {
        let group = ItemGroup(id: UUID(), name: "Work", order: 0)
        return MacMenuConfig(
            items: [
                ManagedItem(id: "com.app.one", appName: "One", bundleId: "com.app.one",
                            visibility: .hidden, groupId: group.id, order: 0),
                ManagedItem(id: "com.app.two", appName: "Two", bundleId: "com.app.two",
                            visibility: .alwaysVisible, order: 1)
            ],
            groups: [group],
            autoCollapseSeconds: 10,
            showDockIcon: true,
            launchAtLogin: true
        )
    }

    func testEncodeDecodeRoundTrip() throws {
        let config = sampleConfig()
        let data = try ConfigStore.encode(config)
        let decoded = try ConfigStore.decode(data)
        XCTAssertEqual(decoded, config)
    }

    func testSaveThenLoadViaPersistence() throws {
        let store = ConfigStore(persistence: InMemoryConfigPersistence())
        let config = sampleConfig()
        try store.save(config)
        XCTAssertEqual(store.load(), config)
    }

    func testLoadEmptyWhenNothingStored() {
        let store = ConfigStore(persistence: InMemoryConfigPersistence())
        XCTAssertEqual(store.load(), .empty)
    }

    func testLoadEmptyOnCorruptData() {
        let corrupt = Data("not json".utf8)
        let store = ConfigStore(persistence: InMemoryConfigPersistence(initial: corrupt))
        XCTAssertEqual(store.load(), .empty)
    }
}
