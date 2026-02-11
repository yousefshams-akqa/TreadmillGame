import Foundation

/// User preferences and calibration settings.
/// Persisted to UserDefaults and used to customize game behavior.
struct UserSettings: Codable, Hashable {
    /// User's stride length in meters (calculated from height or manually set)
    var strideLength: Double
    
    /// Whether haptic feedback is enabled
    var hapticsEnabled: Bool
    
    /// Whether text-to-speech is enabled
    var ttsEnabled: Bool
    
    /// TTS volume (0.0 to 1.0)
    var ttsVolume: Double
    
    /// TTS speech rate (0.0 to 1.0, where 0.5 is normal)
    var ttsSpeechRate: Double
    
    // MARK: - Defaults
    
    static let `default` = UserSettings(
        strideLength: 0.726, // Average stride length (1.75m height * 0.415)
        hapticsEnabled: true,
        ttsEnabled: true,
        ttsVolume: 1.0,
        ttsSpeechRate: 0.5
    )
    
    // MARK: - Stride length calculation
    
    /// Calculate stride length from height in centimeters
    /// Uses the formula: height (m) * 0.415
    static func strideLength(fromHeightCm height: Double) -> Double {
        return (height / 100.0) * 0.415
    }
    
    /// Calculate stride length from height string (cm)
    static func strideLength(fromHeightString height: String) -> Double? {
        guard let heightValue = Double(height) else { return nil }
        return strideLength(fromHeightCm: heightValue)
    }
    
    // MARK: - Persistence
    
    private static let userDefaultsKey = "userSettings"
    
    /// Save settings to UserDefaults
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Self.userDefaultsKey)
        }
    }
    
    /// Load settings from UserDefaults, or return default if not found
    static func load() -> UserSettings {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let settings = try? JSONDecoder().decode(UserSettings.self, from: data) else {
            return .default
        }
        return settings
    }
}
