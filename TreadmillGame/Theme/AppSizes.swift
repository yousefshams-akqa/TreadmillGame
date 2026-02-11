import SwiftUI

/// Centralized size constants for the app
struct AppSizes {
    // MARK: - Button Sizes
    static let buttonHeightSmall: CGFloat = 36
    static let buttonHeightMedium: CGFloat = 44
    static let buttonHeightLarge: CGFloat = 56
    static let buttonMaxHeight: CGFloat = 100
    
    // MARK: - Corner Radius
    static let cornerRadiusSmall: CGFloat = 4
    static let cornerRadiusMedium: CGFloat = 8
    static let cornerRadiusLarge: CGFloat = 12
    static let cornerRadiusXLarge: CGFloat = 20
    
    // MARK: - Border Width
    static let borderThin: CGFloat = 1
    static let borderMedium: CGFloat = 2
    static let borderThick: CGFloat = 3
    
    // MARK: - Progress & Indicator Sizes
    static let progressBarHeight: CGFloat = 8
    static let progressBarHeightSmall: CGFloat = 4
    static let progressBarHeightLarge: CGFloat = 12
    
    // MARK: - Icon Sizes
    static let iconSmall: CGFloat = 16
    static let iconMedium: CGFloat = 24
    static let iconLarge: CGFloat = 32
    static let iconXLarge: CGFloat = 40
    static let iconXXLarge: CGFloat = 60
    
    // MARK: - Container Sizes
    static let cardMaxWidth: CGFloat = 400
    static let overlayPadding: CGFloat = 32
    
    // MARK: - Spacing from AppSpacing (for convenience)
    static let spacing = AppSpacing.self
}
