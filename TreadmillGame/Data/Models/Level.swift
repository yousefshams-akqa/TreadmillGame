import Foundation

/// Complete level configuration containing all data needed to run a game level.
/// Designed to be fetched from a backend and used without code changes.
struct Level: Codable, Hashable, Identifiable {
    /// Schema version for backwards compatibility with older level files
    let schemaVersion: Int
    
    /// Unique identifier for this level
    let id: String
    
    /// Display name for the level
    let name: String
    
    /// Description shown in level selection
    let description: String
    
    // MARK: - Goals
    
    /// Number of steps required to complete the level
    let stepGoal: Int
    
    /// Optional time limit in seconds (nil = no time limit)
    let timeLimit: TimeInterval?
    
    // MARK: - User calibration defaults
    
    /// Default stride length in meters (can be overridden by user settings)
    let defaultStrideLength: Double
    
    // MARK: - Enemies
    
    /// Optional explicit number of enemies for this level.
    /// If missing, a count is derived from step goal and difficulty.
    let enemyCount: Int?
    
    /// Optional static enemy configurations for this level.
    /// Kept for backwards compatibility with older JSON files.
    let enemies: [EnemyConfig]?
    
    // MARK: - Audio
    
    /// Audio configuration for this level
    let audio: LevelAudio
    
    // MARK: - TTS
    
    /// Text-to-speech messages for this level
    let ttsMessages: TTSMessages
    
    // MARK: - Presentation
    
    /// Optional visual theme for the UI
    let theme: LevelTheme?
    
    // MARK: - Difficulty/progression
    
    /// Difficulty rating
    let difficulty: Difficulty
    
    /// Order in story/progression (for sorting levels)
    let order: Int
    
    // MARK: - Current schema version
    
    static let currentSchemaVersion = 1
}

// MARK: - LevelPreview for list UI

/// Minimal level info for displaying in a list (doesn't load full audio/enemy data)
struct LevelPreview: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let description: String
    let difficulty: Difficulty
    let stepGoal: Int
    let theme: LevelTheme?
    let order: Int
    
    init(from level: Level) {
        self.id = level.id
        self.name = level.name
        self.description = level.description
        self.difficulty = level.difficulty
        self.stepGoal = level.stepGoal
        self.theme = level.theme
        self.order = level.order
    }
}
