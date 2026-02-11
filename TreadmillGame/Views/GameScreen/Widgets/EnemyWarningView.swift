import SwiftUI

/// Displays enemy warning with icon, text, and closeness indicator
struct EnemyWarningView: View {
    let closeness: Float
    
    var body: some View {
        VStack(spacing: AppSpacing.verticalSpacing) {
            Image(systemName: warningIcon)
                .font(AppFonts.mediumIcon)
                .foregroundColor(warningColor)
            
            Text(warningText)
                .font(AppFonts.headline(weight: .bold))
                .foregroundColor(warningColor)
            
            // Closeness indicator bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: AppSizes.cornerRadiusSmall)
                        .fill(Color.gray.opacity(0.3))
                    
                    RoundedRectangle(cornerRadius: AppSizes.cornerRadiusSmall)
                        .fill(warningColor)
                        .frame(width: geometry.size.width * CGFloat(closeness))
                }
            }
            .frame(height: AppSizes.progressBarHeight)
            .padding(.horizontal, AppSpacing.huge)
        }
        .padding(AppSpacing.screenPadding)
        .background(
            RoundedRectangle(cornerRadius: AppSizes.cornerRadiusLarge)
                .fill(warningColor.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppSizes.cornerRadiusLarge)
                        .stroke(warningColor.opacity(0.3), lineWidth: AppSizes.borderThin)
                )
        )
        .padding(.horizontal, AppSpacing.screenPadding)
    }
    
    private var warningColor: Color {
        if closeness > 0.7 {
            return AppColors.Enemy.danger
        } else if closeness > 0.4 {
            return AppColors.Enemy.approaching
        }
        return AppColors.Enemy.nearby
    }
    
    private var warningIcon: String {
        if closeness > 0.7 {
            return "exclamationmark.triangle.fill"
        } else if closeness > 0.4 {
            return "exclamationmark.triangle"
        }
        return "figure.run"
    }
    
    private var warningText: String {
        if closeness > 0.7 {
            return AppText.Game.dangerWarning
        } else if closeness > 0.4 {
            return AppText.Game.enemyApproaching
        }
        return AppText.Game.enemyNearby
    }
}

#Preview {
    VStack(spacing: AppSpacing.xl) {
        EnemyWarningView(closeness: 0.3)
        EnemyWarningView(closeness: 0.6)
        EnemyWarningView(closeness: 0.9)
    }
    .padding()
}
