import Foundation

/// Difficulty tuning parameters used by enemy generation.
struct DifficultyProfile {
    /// Number of generated enemies per 1000 goal steps.
    let enemyDensityPerThousandSteps: Double
    
    /// If player is this many steps ahead of an active enemy, despawn that enemy.
    let escapeDistanceSteps: Double
    
    /// Minimum and maximum enemy speed in steps/second.
    let spsMin: Double
    let spsMax: Double
    
    /// Minimum and maximum chase distance before the enemy gives up.
    let maxStepsMin: Double
    let maxStepsMax: Double
    
    static let easy = DifficultyProfile(
        enemyDensityPerThousandSteps: 5.0,
        escapeDistanceSteps: 35.0,
        spsMin: 1.0,
        spsMax: 1.8,
        maxStepsMin: 110,
        maxStepsMax: 190
    )
    
    static let medium = DifficultyProfile(
        enemyDensityPerThousandSteps: 6.0,
        escapeDistanceSteps: 30.0,
        spsMin: 1.2,
        spsMax: 2.3,
        maxStepsMin: 120,
        maxStepsMax: 220
    )
    
    static let hard = DifficultyProfile(
        enemyDensityPerThousandSteps: 7.0,
        escapeDistanceSteps: 25.0,
        spsMin: 1.2,
        spsMax: 2.3,
        maxStepsMin: 130,
        maxStepsMax: 260
    )
    
    static let extreme = DifficultyProfile(
        enemyDensityPerThousandSteps: 9.0,
        escapeDistanceSteps: 22.0,
        spsMin: 1.2,
        spsMax: 2.3,
        maxStepsMin: 140,
        maxStepsMax: 300
    )
    
    static let fallback = DifficultyProfile(
        enemyDensityPerThousandSteps: 6.0,
        escapeDistanceSteps: 30.0,
        spsMin: 1.2,
        spsMax: 2.3,
        maxStepsMin: 120,
        maxStepsMax: 220
    )
    
    static func resolve(for difficulty: Difficulty) -> DifficultyProfile {
        switch difficulty.rawValue {
        case Difficulty.easy:
            return .easy
        case Difficulty.medium:
            return .medium
        case Difficulty.hard:
            return .hard
        case Difficulty.extreme:
            return .extreme
        default:
            return .fallback
        }
    }
}
