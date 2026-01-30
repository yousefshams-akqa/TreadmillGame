import Foundation

@MainActor
class GameController : ObservableObject {
    var stepsRepo : StepsRepository
    var hapticService : HapticsService
    
    @Published var steps : Int64 = 0
    @Published var speed : Double = 0
    @Published var distance : Float = 0

    init(stepsRepo: StepsRepository, hapticService: HapticsService) {
        self.stepsRepo = stepsRepo
        self.hapticService = hapticService
    }
    
    func startSteps() async throws {
        stepsRepo.start()
        try? await Task.sleep(for: .seconds(2))
        if stepsRepo.stepsStream == nil {
            throw StepsError.streamError
        }
        for await stepsResult in stepsRepo.stepsStream {
            self.steps = stepsResult.steps
            hapticsHandler(steps: steps, stepsResult: stepsResult)
            self.speed = stepsResult.speed
            self.distance = Float(stepsResult.distance)
        }
    }
    
    func hapticsHandler(steps : Int64, stepsResult : StepsResult) {
        if steps == 1 {
            try? hapticService.initEngine()
        }
        if stepsResult.hasStoppedMoving {
            try? hapticService.grassPlayer.pause(atTime: 0)
        }
        else {
            try? hapticService.grassPlayer.resume(atTime: 0)
        }
    }
    
    func dispose() {
        hapticService.dispose()
        stepsRepo.stop()
    }
    
    
}

enum StepsError : Error {
    case streamError
}
