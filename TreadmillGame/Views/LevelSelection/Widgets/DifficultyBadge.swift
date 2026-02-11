import SwiftUI

struct DifficultyBadge: View {
    let difficulty: Difficulty
    /// Optional theme color to use instead of difficulty default
    var themeColor: Color?
    
    var body: some View {
        Text(difficulty.displayName)
            .font(AppFonts.caption(weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xs)
            .background(
                RoundedRectangle(cornerRadius: AppSizes.cornerRadiusSmall)
                    .fill(badgeColor)
            )
    }
    
    /// Uses theme color if provided, otherwise falls back to gray
    private var badgeColor: Color {
        themeColor ?? .gray
    }
}

#Preview {
    VStack(spacing: AppSpacing.md) {
        HStack(spacing: AppSpacing.md) {
            DifficultyBadge(difficulty: Difficulty("easy"), themeColor: .green)
            DifficultyBadge(difficulty: Difficulty("medium"), themeColor: .orange)
            DifficultyBadge(difficulty: Difficulty("hard"), themeColor: .red)
            DifficultyBadge(difficulty: Difficulty("extreme"), themeColor: .purple)
        }
        // Custom difficulty with theme color
        DifficultyBadge(difficulty: Difficulty("nightmare"), themeColor: .black)
    }
    .padding()
}
