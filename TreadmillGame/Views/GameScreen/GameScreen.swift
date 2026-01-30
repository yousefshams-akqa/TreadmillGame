import SwiftUI

struct GameScreen: View {
    @EnvironmentObject private var gameController : GameController
    var userData : UserModel
    var body: some View {
        HStack {
            Text("Steps: \(gameController.steps)")
            Text("\(String(format: "Speed: %.2f", gameController.speed)) km/h")
            Text("\(String(format: "Distance: %.2f", gameController.distance)) km")

        }
        .onDisappear {
            gameController.dispose()
        }
        .task {
            do {
                try await gameController.startSteps()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    GameScreen(
        userData: UserModel(name: "", age: "", weight: "", height: "")
    ).environmentObject(GameController(stepsRepo: StepsRepository.instance, hapticService: HapticsService()))
}
