import Foundation
import SwiftUI

/// Difficulty level that can be decoded from any string value in JSON.
/// Known difficulties have predefined colors; unknown ones use the theme color.
struct Difficulty: Codable, Hashable {
    let rawValue: String

    /// Baseline treadmill speed ramp / user reaction time in seconds.
    /// This is a constant used to ensure the catch grace never feels instant.
    static let treadmillResponseSeconds: Double = 1.0

    static let easy: String = "easy"
    static let medium: String = "medium"
    static let hard: String = "hard"
    static let extreme: String = "extreme"
    
    init(_ value: String) {
        self.rawValue = value.lowercased()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.rawValue = value.lowercased()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    /// Display name (capitalized)
    var displayName: String {
        rawValue.capitalized
    }

    var isEasy: Bool {
        rawValue == Difficulty.easy
    }

    /// Minimum enemy speed advantage in steps/second (Medium+ only).
    var enemyDeltaSps: Double {
        switch rawValue {
        case Difficulty.easy:
            return 0.0
        case Difficulty.medium:
            return 0.4
        case Difficulty.hard:
            return 0.7
        case Difficulty.extreme:
            return 1.0
        default:
            return 0.0
        }
    }

    /// Minimum catch grace in seconds (used as a floor).
    /// Derived from a constant treadmill response time plus a difficulty-based bonus.
    var minCatchGraceSeconds: Double {
        let bonus: Double
        switch rawValue {
        case Difficulty.easy:
            bonus = 1.5
        case Difficulty.medium:
            bonus = 1.0
        case Difficulty.hard:
            bonus = 0.5
        case Difficulty.extreme:
            bonus = 0.0
        default:
            bonus = 1.0
        }
        return Self.treadmillResponseSeconds + bonus
    }
    
}
