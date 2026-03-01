import Foundation

/// Resolved runtime configuration for a game session.
/// Combines Level data with UserSettings to produce effective values.
struct GameSessionConfig {
    /// The level being played
    let level: Level
    
    /// User settings applied to this session
    let userSettings: UserSettings
    
    // MARK: - Effective values (Level + UserSettings combined)
    
    /// Effective stride length (user setting if valid, otherwise level default)
    var effectiveStrideLength: Double {
        userSettings.strideLength > 0 ? userSettings.strideLength : level.defaultStrideLength
    }
    
    /// Step goal from the level
    var stepGoal: Int {
        level.stepGoal
    }
    
    /// Time limit from the level (nil = no limit)
    var timeLimit: TimeInterval? {
        level.timeLimit
    }
    
    /// Whether haptics are enabled
    var hapticsEnabled: Bool {
        userSettings.hapticsEnabled
    }
    
    /// Whether TTS is enabled
    var ttsEnabled: Bool {
        userSettings.ttsEnabled
    }
    
    /// TTS volume
    var ttsVolume: Double {
        userSettings.ttsVolume
    }
    
    /// TTS speech rate
    var ttsSpeechRate: Double {
        userSettings.ttsSpeechRate
    }
    
    /// Enemy configurations from the level, sorted by spawn step
    var enemies: [EnemyConfig] {
        EnemyGenerationService.generate(for: level)
    }
    
    /// Audio configuration from the level
    var audio: LevelAudio {
        level.audio
    }
    
    /// TTS messages from the level
    var ttsMessages: TTSMessages {
        level.ttsMessages
    }
    
    /// Theme from the level
    var theme: LevelTheme? {
        level.theme
    }
    
    // MARK: - Initialization
    
    init(level: Level, userSettings: UserSettings = .load()) {
        self.level = level
        self.userSettings = userSettings
    }
    
    // MARK: - Convenience factory for testing
    
    /// Create a minimal config for testing/previewing
    static func preview(stepGoal: Int = 100) -> GameSessionConfig {
        let level = Level(
            schemaVersion: Level.currentSchemaVersion,
            id: "preview",
            name: "Preview",
            description: "Preview level",
            stepGoal: stepGoal,
            timeLimit: nil,
            defaultStrideLength: 0.726,
                enemyCount: 8,
                enemies: nil,
            audio: LevelAudio(
                environmentSound: .bundled("winter_wind_sound.mp3"),
                enemySpawnSound: .bundled("enemy_start_sound.mp3"),
                enemyRunningSound: .bundled("enemy_running_sound.mp3"),
                enemyGameOverSound: .bundled("enemy_game_over_sound.mp3"),
                victorySound: .bundled("victory_sound.mp3")
            ),
            ttsMessages: TTSMessages(),
            theme: nil,
            difficulty: Difficulty("easy"),
            order: 0
        )
        return GameSessionConfig(level: level, userSettings: .default)
    }
}
