import SwiftUI

struct AppText {
    struct Game {
        static let victory = "Victory!"
        static let gameOver = "Game Over"
        static let dangerWarning = "DANGER! Run faster!"
        static let enemyApproaching = "Enemy approaching!"
        static let enemyNearby = "Enemy nearby"
        static let restart = "Restart"
        static let exit = "Exit"
    }
    
    struct Stats {
        static let speed = "Speed"
        static let distance = "Distance"
        static let pace = "Pace"
        static let steps = "Steps"
        static let stepsUnit = "steps"
        static let toGo = "to go"
    }
    
    struct StartScreen {
        static let title = "Good to see you!"
        static let subtitle = "Enter your details to get started"
        static let continueButton = "Continue"
        static let nameLabel = "Name"
        static let namePlaceholder = "Your name"
        static let ageLabel = "Age"
        static let agePlaceholder = "Your age"
        static let heightLabel = "Height (cm)"
        static let heightPlaceholder = "e.g. 175"
        static let weightLabel = "Weight (kg)"
        static let weightPlaceholder = "e.g. 70"
    }
    
    struct LevelSelection {
        static let title = "Choose Your Challenge"
        static let subtitle = "Select a level to begin your run"
    }
    
    struct Settings {
        static let title = "Settings"
        static let done = "Done"
        static let feedbackSection = "Feedback"
        static let hapticFeedback = "Haptic Feedback"
        static let voiceFeedback = "Voice Feedback (TTS)"
        static let voiceSection = "Voice Settings"
        static let volume = "Volume"
        static let speechRate = "Speech Rate"
    }
    
    // MARK: - Text Styles (as View Modifiers)
    struct Styles {
        /// Large title style (for main headings)
        static func largeTitle() -> some ViewModifier {
            FontModifier(font: AppFonts.largeTitle(), weight: .bold)
        }
        
        /// Title style (for section headers)
        static func title() -> some ViewModifier {
            FontModifier(font: AppFonts.title(), weight: .semibold)
        }
        
        /// Title2 style (for subsection headers)
        static func title2() -> some ViewModifier {
            FontModifier(font: AppFonts.title2(), weight: .semibold)
        }
        
        /// Headline style (for emphasized text)
        static func headline() -> some ViewModifier {
            FontModifier(font: AppFonts.headline(), weight: .semibold)
        }
        
        /// Headline bold style
        static func headlineBold() -> some ViewModifier {
            FontModifier(font: AppFonts.headline(), weight: .bold)
        }
        
        /// Body style (for regular text)
        static func body() -> some ViewModifier {
            FontModifier(font: AppFonts.body(), weight: .regular)
        }
        
        /// Caption style (for small secondary text)
        static func caption() -> some ViewModifier {
            FontModifier(font: AppFonts.caption(), weight: .regular, color: .secondary)
        }
        
        /// Secondary text style
        static func secondary() -> some ViewModifier {
            FontModifier(font: AppFonts.body(), weight: .regular, color: .secondary)
        }
    }
}

// MARK: - Font Modifier
private struct FontModifier: ViewModifier {
    let font: Font
    let weight: Font.Weight?
    let color: Color?
    
    init(font: Font, weight: Font.Weight? = nil, color: Color? = nil) {
        self.font = font
        self.weight = weight
        self.color = color
    }
    
    func body(content: Content) -> some View {
        let newFont = FontModifier(font: font, weight: weight, color: color).font
        let modified = content.font(newFont)
        return modified
    }
}

// MARK: - View Extensions for Easy Access
extension View {
    func appLargeTitle() -> some View {
        modifier(AppText.Styles.largeTitle())
    }
    
    func appTitle() -> some View {
        modifier(AppText.Styles.title())
    }
    
    func appTitle2() -> some View {
        modifier(AppText.Styles.title2())
    }
    
    func appHeadline() -> some View {
        modifier(AppText.Styles.headline())
    }
    
    func appHeadlineBold() -> some View {
        modifier(AppText.Styles.headlineBold())
    }
    
    func appBody() -> some View {
        modifier(AppText.Styles.body())
    }
    
    func appCaption() -> some View {
        modifier(AppText.Styles.caption())
    }
    
    func appSecondary() -> some View {
        modifier(AppText.Styles.secondary())
    }
}
