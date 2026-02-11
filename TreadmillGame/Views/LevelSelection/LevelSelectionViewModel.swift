import SwiftUI

@MainActor
class LevelSelectionViewModel: ObservableObject {
    @Published var levels: [LevelPreview] = []
    @Published var isLoading = true
    @Published var selectedLevel: Level?
    @Published var showGame = false
    @Published var gameController: GameController?
    
    private let levelRepo = FetchLevelsRepository()
    private let userHeight: String
    
    init(userHeight: String) {
        self.userHeight = userHeight
    }
    
    func loadLevels() async {
        do {
            levels = try await levelRepo.listAvailableLevels()
        } catch {
            print("[LevelSelection] Failed to load levels: \(error)")
        }
        isLoading = false
    }
    
    func selectLevel(id: String) async {
        do {
            let level = try await levelRepo.loadBundledLevel(id: id)
            var userSettings = UserSettings.load()
            if let strideLength = UserSettings.strideLength(fromHeightString: userHeight) {
                userSettings.strideLength = strideLength
            }
            
            let config = GameSessionConfig(level: level, userSettings: userSettings)
            
            self.gameController = GameController(config: config)
            self.showGame = true
        } catch {
            print("[LevelSelection] Failed to load level: \(error)")
        }
    }
}
