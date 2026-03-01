import SwiftUI

struct LevelCard: View {
    let preview: LevelPreview
    let onSelect: () -> Void
    
    /// Uses theme color from JSON, falls back to gray if not defined
    private var accentColor: Color {
        preview.theme?.accentColor ?? .gray
    }
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 0) {
                // Accent bar on the left
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(width: 4)
                    .padding(.vertical, AppSpacing.sm)
                
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    // Header: Title and difficulty badge
                    HStack(alignment: .top) {
                        Text(preview.name)
                            .font(AppFonts.title2())
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        DifficultyBadge(
                            difficulty: preview.difficulty,
                            themeColor: preview.theme?.accentColor
                        )
                    }
                    
                    // Description
                    Text(preview.description)
                        .font(AppFonts.body())
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Footer: Stats and arrow
                    HStack {
                        HStack(spacing: AppSpacing.xs) {
                            Image(systemName: "figure.walk")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(accentColor)
                            
                            Text("\(preview.stepGoal) \(AppText.Stats.stepsUnit)")
                                .font(AppFonts.caption(weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.leading, AppSpacing.md)
                .padding(.trailing, AppSpacing.cardPadding)
                .padding(.vertical, AppSpacing.cardPadding)
            }
            .background(
                RoundedRectangle(cornerRadius: AppSizes.cornerRadiusLarge)
                    .fill(accentColor.opacity(0.05))
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(LevelCardButtonStyle())
    }
}

// MARK: - Button Style

private struct LevelCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    LevelCard(
        preview: LevelPreview(
            from: Level(
                schemaVersion: 1,
                id: "test",
                name: "Test Level",
                description: "A test level for previewing the card",
                stepGoal: 200,
                timeLimit: nil,
                defaultStrideLength: 0.726,
                enemyCount: 6,
                enemies: nil,
                audio: LevelAudio(
                    environmentSound: .bundled("test.mp3"),
                    enemySpawnSound: .bundled("test.mp3"),
                    enemyRunningSound: .bundled("test.mp3"),
                    enemyGameOverSound: .bundled("test.mp3"),
                    victorySound: .bundled("test.mp3")
                ),
                ttsMessages: TTSMessages(),
                theme: LevelTheme(
                    backgroundAsset: nil,
                    accentColorHex: "#E74C3C",
                    environmentLabel: "Test Environment"
                ),
                difficulty: Difficulty("medium"),
                order: 1
            )
        ),
        onSelect: {}
    )
    .padding()
}
