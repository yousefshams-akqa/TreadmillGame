import Foundation

enum GameError: Error, LocalizedError {
    case audioLoadFailed(String)
    case levelLoadFailed(String)
    case hapticEngineFailed
    case stepsStreamFailed
    case invalidConfiguration(String)
    
    var errorDescription: String? {
        switch self {
        case .audioLoadFailed(let name):
            return "Failed to load audio: \(name)"
        case .levelLoadFailed(let id):
            return "Failed to load level: \(id)"
        case .hapticEngineFailed:
            return "Haptic engine initialization failed"
        case .stepsStreamFailed:
            return "Failed to start step detection"
        case .invalidConfiguration(let reason):
            return "Invalid configuration: \(reason)"
        }
    }
}
