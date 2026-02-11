import Foundation

/// Configuration for an enemy that will spawn during gameplay.
/// This is the static configuration from the level data, not the runtime state.
struct EnemyConfig: Codable, Hashable {
    /// The step count at which this enemy will spawn
    let spawnAtStep: Int
    
    /// Maximum number of steps the enemy will chase before giving up
    let maxSteps: Int
    
    /// Enemy movement speed in steps per second
    let stepsPerSecond: Double
    
    /// Catch grace duration in seconds once the enemy reaches/passes the player.
    let catchMargin: Double
    
    // MARK: - Convenience initializer with defaults
    
    init(spawnAtStep: Int, maxSteps: Int = 100, stepsPerSecond: Double = 1.0, catchMargin: Double = 5.0) {
        self.spawnAtStep = spawnAtStep
        self.maxSteps = maxSteps
        self.stepsPerSecond = stepsPerSecond
        self.catchMargin = catchMargin
    }
}
