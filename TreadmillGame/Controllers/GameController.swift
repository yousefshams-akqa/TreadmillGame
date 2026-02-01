import Foundation
import CoreHaptics

@MainActor
class GameController : ObservableObject {
    let stepsRepo : StepsRepository
    let hapticService : HapticsService
    let soundRepo : SoundRepositroy
    let enemiesRepo : EnemiesRepository
    var stepHaptic : CHHapticPatternPlayer!
    let stepsGoal = 200
    
    init(stepsRepo: StepsRepository, hapticService: HapticsService, soundRepo: SoundRepositroy, enemiesRepo: EnemiesRepository) {
        self.stepsRepo = stepsRepo
        self.hapticService = hapticService
        self.soundRepo = soundRepo
        self.enemiesRepo = enemiesRepo
    }

    @Published var steps : Int64 = 0
    @Published var speed : Double = 0
    @Published var distance : Float = 0
    @Published var stepsPerSecond : Int = 0
    @Published var isGameOver = false
    @Published var stepGoalReached = false
    func startGame() async throws {
        try await initialize()
        
        // Handle step results
        for await stepsResult in stepsRepo.stepsStream {
            if !isGameOver {
                let previousStep = self.steps
                self.steps = stepsResult.steps
                self.speed = stepsResult.speed
                self.distance = Float(stepsResult.distance)
                self.stepsPerSecond = stepsResult.stepsPerSecond
                hapticsHandler(steps: steps, stepsResult: stepsResult, previousStep: previousStep)
                enemiesRepo.handleEnemyLifeCycle(playerSteps: steps, gameOverCallback: gameOverCallback, soundRepo: soundRepo)
                stepsGoalGameOverHandler()
            }
        }
    }
    
    func hapticsHandler(steps : Int64, stepsResult : StepsResult, previousStep : Int64) {
        do {
            if steps == 1 {
                try hapticService.initEngine()
                stepHaptic = try? HapticsPatterns.getHapticPlayerFromPattern(pattern: HapticsPatterns.getStepPattern(), engine: hapticService.engine)
            }
            if steps > 0 && hapticService.isInit && steps > previousStep {
                //try? stepHaptic?.start(atTime: 0)
            }
        }
        catch {
            print("hapticsHandler ERROR: \(error)")
        }
    }

    
    func gameOverCallback(_ goalReached : Bool = false) {
        self.isGameOver = true
        self.stepGoalReached = goalReached
        enemiesRepo.destoryEnemy()
        
        if !stepGoalReached {
            let pattern = try? HapticsPatterns.getGameOverPattern()
            try? hapticService.playPattern(pattern: pattern!)
            soundRepo.startEnemyGameOverSound()
        }
        else {
            soundRepo.playVictorySound()
        }

        soundRepo.stopEnvironmentSound()
        soundRepo.stopEnemyRunningSound()
        
    }
    
    func stepsGoalGameOverHandler() {
        if steps >= stepsGoal {
            gameOverCallback(true)
        }
    }
    
    func dispose() {
        hapticService.dispose()
        stepsRepo.stop()
        soundRepo.dispose()
        try? stepHaptic.cancel()
    }
    
    
    func initialize() async throws {
        // Start steps counting
        stepsRepo.start()
        soundRepo.initialize()
        enemiesRepo.enemyAudioPlayer = soundRepo.enemyAudio
        
        try? await Task.sleep(for: .seconds(2))
        if stepsRepo.stepsStream == nil {
            throw StepsError.streamError
        }
        
        // Start environment sound
        soundRepo.playEnvironmentSound()
    }
    
}

enum StepsError : Error {
    case streamError
}
