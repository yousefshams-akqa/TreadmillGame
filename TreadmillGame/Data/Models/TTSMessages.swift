import Foundation

/// Text-to-speech messages for a level, providing audio feedback during gameplay.
struct TTSMessages: Codable, Hashable {
    /// Message spoken when an enemy starts approaching (medium closeness)
    let enemyApproaching: String?
    
    /// Message spoken when an enemy is very close (high closeness)
    let enemyClose: String?
    
    /// Messages triggered at specific remaining step counts
    let stepsRemaining: [StepsRemainingCue]
    
    /// Random motivational messages spoken during gameplay
    let motivational: [String]
    
    /// Message spoken on victory
    let victory: String
    
    /// Message spoken on defeat
    let defeat: String
    
    // MARK: - Convenience initializer with defaults
    
    init(
        enemyApproaching: String? = nil,
        enemyClose: String? = nil,
        stepsRemaining: [StepsRemainingCue] = [],
        motivational: [String] = [],
        victory: String = "Congratulations! You made it!",
        defeat: String = "Game over. Better luck next time!"
    ) {
        self.enemyApproaching = enemyApproaching
        self.enemyClose = enemyClose
        self.stepsRemaining = stepsRemaining
        self.motivational = motivational
        self.victory = victory
        self.defeat = defeat
    }
    
    // MARK: - Helpers
    
    /// Find the message for a specific remaining step count
    func message(forRemainingSteps steps: Int) -> String? {
        stepsRemaining.first { $0.remainingSteps == steps }?.text
    }
}
