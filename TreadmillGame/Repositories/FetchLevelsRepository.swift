import Foundation

/// Container for the levels JSON file
private struct LevelsFile: Codable {
    let schemaVersion: Int
    let levels: [Level]
}

/// Repository for loading and managing game levels.
class FetchLevelsRepository {
    
    /// Cached levels after first load
    private var cachedLevels: [Level]?
    
    // MARK: - Loading bundled levels
    
    /// Load a level by ID
    func loadBundledLevel(id: String) async throws -> Level {
        let levels = try await loadAllBundledLevels()
        guard let level = levels.first(where: { $0.id == id }) else {
            throw LevelError.notFound(id)
        }
        return level
    }
    
    /// Load all bundled levels from the consolidated levels.json file
    func loadAllBundledLevels() async throws -> [Level] {
        // Return cached levels if available
        if let cached = cachedLevels {
            return cached
        }
        
        guard let url = Bundle.main.url(forResource: "levels", withExtension: "json") else {
            throw LevelError.notFound("levels.json")
        }
        
        let data = try Data(contentsOf: url)
        let levelsFile = try decodeLevelsFile(from: data)
        
        // Validate schema version
        if levelsFile.schemaVersion > Level.currentSchemaVersion {
            throw LevelError.invalidSchemaVersion(levelsFile.schemaVersion, expected: Level.currentSchemaVersion)
        }
        
        let sortedLevels = levelsFile.levels.sorted { $0.order < $1.order }
        cachedLevels = sortedLevels
        return sortedLevels
    }
    
    /// Get previews for all available levels (bundled)
    func listAvailableLevels() async throws -> [LevelPreview] {
        let levels = try await loadAllBundledLevels()
        return levels.map { LevelPreview(from: $0) }
    }
    
    /// Clear the cached levels (useful for testing or refreshing)
    func clearCache() {
        cachedLevels = nil
    }
    
    // MARK: - Private helpers
    
    private func decodeLevelsFile(from data: Data) throws -> LevelsFile {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(LevelsFile.self, from: data)
        } catch let error as DecodingError {
            throw LevelError.invalidData(error.localizedDescription)
        }
    }
}

/// Errors that can occur when loading levels
enum LevelError: Error, LocalizedError {
    case notFound(String)
    case invalidData(String)
    case invalidSchemaVersion(Int, expected: Int)
    case networkError(Error)
    case validationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Level '\(id)' not found"
        case .invalidData(let reason):
            return "Invalid level data: \(reason)"
        case .invalidSchemaVersion(let version, let expected):
            return "Unsupported schema version \(version) (expected \(expected))"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .validationFailed(let reason):
            return "Level validation failed: \(reason)"
        }
    }
}
