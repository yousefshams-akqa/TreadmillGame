import SwiftUI
import CoreMotion

struct GameScreen: View {
    @EnvironmentObject private var gameController: GameController
    @Environment(\.dismiss) private var dismiss
    var userData: UserModel
    
    var body: some View {
        ZStack {
            VStack(spacing: AppSpacing.sectionSpacing) {
                LevelHeaderView(levelName: gameController.levelName)
                
                ProgressSectionView(
                    progress: Float(gameController.progress),
                    steps: Int(gameController.steps),
                    stepGoal: gameController.stepGoal,
                    progressColor: progressColor
                )
                
                Spacer()
                
                if gameController.hasActiveEnemy {
                    EnemyWarningView(closeness: gameController.enemyCloseness)
                }
                
                Spacer()
                
                StatsView(
                    speed: gameController.speed,
                    distance: Double(gameController.distance),
                    stepsPerSecond: gameController.stepsPerSecond
                )
                
                Spacer()
            }
            .padding(AppSpacing.screenPadding)
            .blur(radius: gameController.isGameOver ? 3 : 0)
            
            if gameController.isGameOver {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                GameOverOverlay(
                    didWin: gameController.stepGoalReached,
                    steps: Int(gameController.steps),
                    distance: Double(gameController.distance),
                    onRestart: {
                        gameController.restart()
                    },
                    onExit: {
                        dismiss()
                    }
                )
                .padding(.horizontal, AppSpacing.screenPadding)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            gameController.dispose()
        }
        .task {
            do {
                try await gameController.startGame()
            } catch {
                print("[GameScreen] Error starting game: \(error.localizedDescription)")
            }
        }
    }
    
    private var progressColor: Color {
        if gameController.stepGoalReached {
            return AppColors.Progress.complete
        } else if gameController.enemyCloseness > 0.7 {
            return AppColors.Progress.danger
        } else if gameController.enemyCloseness > 0.4 {
            return AppColors.Progress.moderate
        }
        return AppColors.Progress.normal
    }
}

#Preview {
    let config = GameSessionConfig.preview(stepGoal: 200)
    let controller = GameController(config: config)
    
    return GameScreen(
        userData: UserModel(name: "", age: "", weight: "", height: "")
    ).environmentObject(controller)
}
