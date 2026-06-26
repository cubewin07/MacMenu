import Foundation

/// Encodes/decodes `MacMenuConfig` (ADR 0005). The actual persistence backend
/// (UserDefaults / file) is injected so the pure encode-decode logic is testable
/// without touching disk. The app provides a concrete `ConfigPersistence`.
public protocol ConfigPersistence: Sendable {
    func loadData() -> Data?
    func saveData(_ data: Data) throws
}

public struct ConfigStore: Sendable {
    private let persistence: ConfigPersistence

    public init(persistence: ConfigPersistence) {
        self.persistence = persistence
    }

    /// Load config, returning `.empty` if nothing is stored or decoding fails.
    public func load() -> MacMenuConfig {
        guard let data = persistence.loadData() else { return .empty }
        do {
            return try Self.decode(data)
        } catch {
            // Corrupt/incompatible config should not break startup.
            return .empty
        }
    }

    public func save(_ config: MacMenuConfig) throws {
        try persistence.saveData(try Self.encode(config))
    }

    // Pure, testable encode/decode.

    public static func encode(_ config: MacMenuConfig) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return try encoder.encode(config)
    }

    public static func decode(_ data: Data) throws -> MacMenuConfig {
        try JSONDecoder().decode(MacMenuConfig.self, from: data)
    }
}

/// An in-memory `ConfigPersistence` for tests and previews.
public final class InMemoryConfigPersistence: ConfigPersistence, @unchecked Sendable {
    private var storage: Data?
    public init(initial: Data? = nil) { self.storage = initial }
    public func loadData() -> Data? { storage }
    public func saveData(_ data: Data) throws { storage = data }
}
