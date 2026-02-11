import SwiftUI

/// Centralized font definitions for the app
struct AppFonts {
    // MARK: - Sizes
    static let largeTitle: CGFloat = 34
    static let title: CGFloat = 28
    static let title2: CGFloat = 22
    static let headline: CGFloat = 17
    static let body: CGFloat = 17
    static let callout: CGFloat = 16
    static let subheadline: CGFloat = 15
    static let caption: CGFloat = 12
    static let caption2: CGFloat = 11
    
    // MARK: - Icon Sizes
    static let iconSmall: CGFloat = 20
    static let iconMedium: CGFloat = 40
    static let iconLarge: CGFloat = 60
    
    // MARK: - Custom Font Styles
    static func largeTitle(weight: Font.Weight = .bold) -> Font {
        .system(size: largeTitle, weight: weight)
    }
    
    static func title(weight: Font.Weight = .semibold) -> Font {
        .system(size: title, weight: weight)
    }
    
    static func title2(weight: Font.Weight = .semibold) -> Font {
        .system(size: title2, weight: weight)
    }
    
    static func headline(weight: Font.Weight = .semibold) -> Font {
        .system(size: headline, weight: weight)
    }
    
    static func body(weight: Font.Weight = .regular) -> Font {
        .system(size: body, weight: weight)
    }
    
    static func callout(weight: Font.Weight = .regular) -> Font {
        .system(size: callout, weight: weight)
    }
    
    static func subheadline(weight: Font.Weight = .regular) -> Font {
        .system(size: subheadline, weight: weight)
    }
    
    static func caption(weight: Font.Weight = .regular) -> Font {
        .system(size: caption, weight: weight)
    }
    
    static func caption2(weight: Font.Weight = .regular) -> Font {
        .system(size: caption2, weight: weight)
    }
    
    // MARK: - Icon Fonts
    static func icon(size: CGFloat) -> Font {
        .system(size: size)
    }
    
    static var smallIcon: Font {
        .system(size: iconSmall)
    }
    
    static var mediumIcon: Font {
        .system(size: iconMedium)
    }
    
    static var largeIcon: Font {
        .system(size: iconLarge)
    }
}
