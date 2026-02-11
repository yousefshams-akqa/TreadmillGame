import Foundation

/// Represents an audio source that can be either bundled with the app or fetched remotely.
/// Uses a tagged struct for JSON-friendly serialization (avoids Swift enum associated values).
struct AudioSource: Codable, Hashable {
    enum Kind: String, Codable {
        case bundled
        case remote
    }
    
    let kind: Kind
    /// For bundled: the file name (e.g., "winter_wind_sound.mp3")
    /// For remote: the absolute URL string
    let value: String
    
    // MARK: - Convenience initializers
    
    static func bundled(_ fileName: String) -> AudioSource {
        AudioSource(kind: .bundled, value: fileName)
    }
    
    static func remote(_ urlString: String) -> AudioSource {
        AudioSource(kind: .remote, value: urlString)
    }
    
    // MARK: - URL resolution
    
    /// Returns the URL for this audio source, or nil if invalid
    func resolveURL() -> URL? {
        switch kind {
        case .bundled:
            return Bundle.main.url(forResource: value, withExtension: nil)
        case .remote:
            return URL(string: value)
        }
    }
}
