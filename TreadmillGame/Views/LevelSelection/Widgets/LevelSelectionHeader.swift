import SwiftUI

struct LevelSelectionHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: AppSpacing.md) {
                // Icon
                Image(systemName: "figure.run.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(AppText.LevelSelection.title)
                        .font(AppFonts.title())
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.Text.primary)
                    
                    Text(AppText.LevelSelection.subtitle)
                        .font(AppFonts.subheadline())
                        .foregroundColor(AppColors.Text.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.screenPadding)
            .padding(.vertical, AppSpacing.xl)
            .background(
                LinearGradient(
                    colors: [
                        AppColors.Background.secondary,
                        AppColors.Background.primary
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Subtle divider
            Rectangle()
                .fill(AppColors.secondary.opacity(0.2))
                .frame(height: 1)
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        LevelSelectionHeader()
        Spacer()
    }
}
