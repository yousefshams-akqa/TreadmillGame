import Foundation

/// A TTS cue that triggers when a specific number of steps remain until the goal.
struct StepsRemainingCue: Codable, Hashable {
    /// The number of remaining steps at which to trigger this cue
    let remainingSteps: Int
    
    /// The text to speak via TTS
    let text: String
}
