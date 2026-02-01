import SwiftUI
import CoreMotion

struct GameScreen: View {
    @EnvironmentObject private var gameController : GameController
    var userData : UserModel
    var body: some View {
        HStack {
            Text("Steps: \(gameController.steps)")
            Text("Steps Per Second: \(gameController.stepsPerSecond)")
            Text("\(String(format: "Distance: %.2f", gameController.distance)) km")

        }
        .onDisappear {
            gameController.dispose()
        }
        .task {
            do {
                try await gameController.startGame()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

#Preview {
    let hapticService = HapticsService()
    let stepsRepo = StepsRepository(motionManager: CMMotionManager())
    let soundRepo = SoundRepositroy()
    let enemiesRepo = EnemiesRepository(hapticService: hapticService)
    let controller = GameController(stepsRepo: stepsRepo, hapticService: hapticService, soundRepo: soundRepo, enemiesRepo: enemiesRepo)
    GameScreen(
        userData: UserModel(name: "", age: "", weight: "", height: "")
    ).environmentObject(controller)
}
