import SwiftUI

/// Centralized spacing constants for the app
struct AppSpacing {
    // MARK: - Base Spacing Units
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
    static let huge: CGFloat = 40
    static let massive: CGFloat = 60
    
    // MARK: - Semantic Spacing
    
    /// Standard padding for screen edges
    static let screenPadding: CGFloat = lg
    
    /// Standard padding for cards and containers
    static let cardPadding: CGFloat = lg
    
    /// Spacing between major sections
    static let sectionSpacing: CGFloat = xl
    
    /// Spacing between related items
    static let itemSpacing: CGFloat = sm
    
    /// Spacing between form fields
    static let fieldSpacing: CGFloat = md
    
    /// Horizontal padding for content
    static let horizontalPadding: CGFloat = xxxl
    
    /// Vertical spacing for stacked elements
    static let verticalSpacing: CGFloat = sm
}
