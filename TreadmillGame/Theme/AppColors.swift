import SwiftUI

/// Centralized color definitions for the app
struct AppColors {
    // MARK: - Primary Colors
    static let primary = Color.blue
    static let secondary = Color.gray
    static let accent = Color.green
    
    // MARK: - Status Colors
    static let success = Color.green
    static let warning = Color.orange
    static let danger = Color.red
    static let info = Color.yellow
    
    // MARK: - Game-Specific Colors
    struct Progress {
        static let normal = Color.blue
        static let moderate = Color.orange
        static let danger = Color.red
        static let complete = Color.green
    }
    
    struct Enemy {
        static let nearby = Color.yellow
        static let approaching = Color.orange
        static let danger = Color.red
    }
    
    struct GameOver {
        static let victory = Color.yellow
        static let defeat = Color.red
    }
    
    // MARK: - Background Colors
    struct Background {
        static let primary = Color(.systemBackground)
        static let secondary = Color(.secondarySystemBackground)
        static let tertiary = Color(.tertiarySystemBackground)
    }
    
    // MARK: - Text Colors
    struct Text {
        static let primary = Color.primary
        static let secondary = Color.secondary
        static let tertiary = Color(.tertiaryLabel)
    }
    
    // MARK: - Overlay Colors
    static func overlay(opacity: Double = 0.1) -> Color {
        Color.black.opacity(opacity)
    }
    
    static func tint(color: Color, opacity: Double = 0.1) -> Color {
        color.opacity(opacity)
    }
}
