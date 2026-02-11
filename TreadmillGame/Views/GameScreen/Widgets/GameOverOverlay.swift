import SwiftUI

struct GameOverOverlay: View {
    let didWin: Bool
    let steps: Int
    let distance: Double
    var onRestart: (() -> Void)?
    var onExit: (() -> Void)?
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Image(systemName: didWin ? "trophy.fill" : "xmark.circle.fill")
                .font(AppFonts.largeIcon)
                .foregroundColor(didWin ? AppColors.GameOver.victory : AppColors.GameOver.defeat)
            
            Text(didWin ? AppText.Game.victory : AppText.Game.gameOver)
                .font(AppFonts.largeTitle(weight: .bold))
            
            VStack(spacing: AppSpacing.verticalSpacing) {
                Text("\(AppText.Stats.steps): \(steps)")
                Text(String(format: "\(AppText.Stats.distance): %.2f km", distance))
            }
            .font(AppFonts.headline())
            .foregroundColor(.secondary)
            
            if onRestart != nil || onExit != nil {
                HStack(spacing: AppSpacing.lg) {
                    if let onExit = onExit {
                        Button(action: onExit) {
                            Label(AppText.Game.exit, systemImage: "xmark")
                                .font(AppFonts.headline())
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppSpacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: AppSizes.cornerRadiusMedium)
                                        .fill(AppColors.Background.secondary)
                                )
                        }
                    }
                    
                    if let onRestart = onRestart {
                        Button(action: onRestart) {
                            Label(AppText.Game.restart, systemImage: "arrow.clockwise")
                                .font(AppFonts.headline(weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppSpacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: AppSizes.cornerRadiusMedium)
                                        .fill(AppColors.primary)
                                )
                        }
                    }
                }
                .padding(.top, AppSpacing.sm)
            }
        }
        .padding(AppSizes.overlayPadding)
        .background(
            RoundedRectangle(cornerRadius: AppSizes.cornerRadiusXLarge)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        
        VStack(spacing: AppSpacing.huge) {
            GameOverOverlay(didWin: true, steps: 523, distance: 2.34, onRestart: {}, onExit: {})
            GameOverOverlay(didWin: false, steps: 145, distance: 0.87, onRestart: {}, onExit: {})
        }
    }
}
