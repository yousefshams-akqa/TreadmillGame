import Foundation
import SwiftUI

/// Visual theme configuration for a level.
struct LevelTheme: Codable, Hashable {
    /// Background asset name (bundled image) or remote URL
    let backgroundAsset: String?
    
    /// Accent color as hex string (e.g., "#FF5733")
    let accentColorHex: String?
    
    /// Label describing the environment (e.g., "Winter Storm", "Dark Forest")
    let environmentLabel: String?
    
    // MARK: - Computed properties
    
    /// Parse the accent color hex string into a SwiftUI Color
    var accentColor: Color? {
        guard let hex = accentColorHex else { return nil }
        return Color(hex: hex)
    }
}

// MARK: - Color extension for hex parsing

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let length = hexSanitized.count
        
        switch length {
        case 6: // RGB
            self.init(
                red: Double((rgb & 0xFF0000) >> 16) / 255.0,
                green: Double((rgb & 0x00FF00) >> 8) / 255.0,
                blue: Double(rgb & 0x0000FF) / 255.0
            )
        case 8: // ARGB
            self.init(
                red: Double((rgb & 0x00FF0000) >> 16) / 255.0,
                green: Double((rgb & 0x0000FF00) >> 8) / 255.0,
                blue: Double(rgb & 0x000000FF) / 255.0,
                opacity: Double((rgb & 0xFF000000) >> 24) / 255.0
            )
        default:
            return nil
        }
    }
}
