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
}
