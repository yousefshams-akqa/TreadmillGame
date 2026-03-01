import Foundation

/// Audio configuration for a level, defining all sound assets used during gameplay.
struct LevelAudio: Codable, Hashable {
    /// Background/ambient sound that plays throughout the level
    let environmentSound: AudioSource
    
    /// Sound that plays when an enemy spawns
    let enemySpawnSound: AudioSource
    
    /// Looping sound that plays while an enemy is chasing the player
    let enemyRunningSound: AudioSource
    
    /// Sound that plays when the enemy catches the player (game over)
    let enemyGameOverSound: AudioSource
    
    /// Sound that plays when the player wins
    let victorySound: AudioSource

    init(
        environmentSound: AudioSource,
        enemySpawnSound: AudioSource,
        enemyRunningSound: AudioSource,
        enemyGameOverSound: AudioSource,
        victorySound: AudioSource
    ) {
        self.environmentSound = environmentSound
        self.enemySpawnSound = enemySpawnSound
        self.enemyRunningSound = enemyRunningSound
        self.enemyGameOverSound = enemyGameOverSound
        self.victorySound = victorySound
    }

    /// Shared default audio used when JSON has `"audio": null`.
    static let `default` = LevelAudio(
        environmentSound: AudioSource.bundled("winter_wind_sound.mp3"),
        enemySpawnSound: AudioSource.bundled("enemy_start_sound.mp3"),
        enemyRunningSound: AudioSource.bundled("enemy_running_sound.mp3"),
        enemyGameOverSound: AudioSource.bundled("enemy_game_over_sound.mp3"),
        victorySound: AudioSource.bundled("victory_sound.mp3")
    )

    init(from decoder: Decoder) throws {
        if let singleValue = try? decoder.singleValueContainer(), singleValue.decodeNil() {
            self = .default
            return
        }

        let raw = try RawLevelAudio(from: decoder)
        self.environmentSound = raw.environmentSound
        self.enemySpawnSound = raw.enemySpawnSound
        self.enemyRunningSound = raw.enemyRunningSound
        self.enemyGameOverSound = raw.enemyGameOverSound
        self.victorySound = raw.victorySound
    }
}

private struct RawLevelAudio: Codable {
    let environmentSound: AudioSource
    let enemySpawnSound: AudioSource
    let enemyRunningSound: AudioSource
    let enemyGameOverSound: AudioSource
    let victorySound: AudioSource
}
