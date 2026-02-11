import Foundation
import CoreHaptics

@MainActor
class GameController: ObservableObject {
    let stepsRepo: StepsRepository
    let hapticService: HapticsService
    let soundRepo: SoundRepository
    let enemiesRepo: EnemiesRepository
    let ttsService: TTSService
    
    let config: GameSessionConfig
    
    var stepGoal: Int { config.stepGoal }
    
    var stepHaptic: CHHapticPatternPlayer?
    private var gameTask: Task<Void, Error>?
    private var enemyTickTask: Task<Void, Never>?
    private var lastSpokenStepsRemaining: Int?
    private var lastEnemyWarningLevel: Int = 0
    
    @Published var steps: Int64 = 0
    @Published var speed: Double = 0
    @Published var distance: Float = 0
    @Published var stepsPerSecond: Int = 0
    @Published var isGameOver = false
    @Published var stepGoalReached = false
    @Published var enemyCloseness: Float = 0
    @Published var hasActiveEnemy: Bool = false
    
    init(
        config: GameSessionConfig,
        stepsRepo: StepsRepository,
        hapticService: HapticsService,
        soundRepo: SoundRepository,
        enemiesRepo: EnemiesRepository,
        ttsService: TTSService
    ) {
        self.config = config
        self.stepsRepo = stepsRepo
        self.hapticService = hapticService
        self.soundRepo = soundRepo
        self.enemiesRepo = enemiesRepo
        self.ttsService = ttsService
        
        enemiesRepo.configure(with: config.enemies)
    }
    
    convenience init(config: GameSessionConfig) {
        let hapticService = HapticsService()
        let enemiesRepo = EnemiesRepository(hapticService: hapticService, enemyConfigs: config.enemies)
        
        let ttsService = TTSService.shared
        ttsService.configure(
            enabled: config.ttsEnabled,
            volume: config.ttsVolume,
            rate: config.ttsSpeechRate
        )
        
        self.init(
            config: config,
            stepsRepo: StepsRepository(motionManager: .init()),
            hapticService: hapticService,
            soundRepo: SoundRepository(),
            enemiesRepo: enemiesRepo,
            ttsService: ttsService
        )
    }
    
    func startGame() async throws {
        try await initialize()

        startEnemyTick()
        defer { stopEnemyTick() }
        
        for await stepsResult in stepsRepo.stepsStream {
            if !isGameOver {
                let previousStep = self.steps
                self.steps = stepsResult.steps
                self.speed = stepsResult.speed
                self.distance = Float(stepsResult.distance)
                self.stepsPerSecond = stepsResult.stepsPerSecond
                
                hapticsHandler(steps: steps, stepsResult: stepsResult, previousStep: previousStep)
                
                checkTTSTriggers()
                stepsGoalGameOverHandler()
            }
        }
    }
    
    func hapticsHandler(steps: Int64, stepsResult: StepsResult, previousStep: Int64) {
        guard config.hapticsEnabled else { return }
        
        if steps > 0 && hapticService.isInit && steps > previousStep {
            try? stepHaptic?.start(atTime: 0)
        }
    }
    
    private func checkTTSTriggers() {
        guard config.ttsEnabled else { return }
        
        let remaining = stepsRemaining
        
        if let message = config.ttsMessages.message(forRemainingSteps: remaining) {
            if lastSpokenStepsRemaining != remaining {
                ttsService.speak(message)
                lastSpokenStepsRemaining = remaining
            }
        }
        
        if hasActiveEnemy {
            let warningLevel: Int
            if enemyCloseness > 0.7 {
                warningLevel = 3
            } else if enemyCloseness > 0.4 {
                warningLevel = 2
            } else {
                warningLevel = 1
            }
            
            if warningLevel > lastEnemyWarningLevel {
                if warningLevel == 3, let msg = config.ttsMessages.enemyClose {
                    ttsService.speak(msg, priority: .high)
                } else if warningLevel == 2, let msg = config.ttsMessages.enemyApproaching {
                    ttsService.speak(msg)
                }
                lastEnemyWarningLevel = warningLevel
            }
        } else {
            lastEnemyWarningLevel = 0
        }
    }

    func gameOverCallback(_ goalReached: Bool = false) {
        self.isGameOver = true
        self.stepGoalReached = goalReached
        stopEnemyTick()
        enemiesRepo.destoryEnemy()
        hasActiveEnemy = false
        enemyCloseness = 0
        
        if !stepGoalReached {
            let pattern = try? HapticsPatterns.getGameOverPattern()
            if let pattern = pattern {
                try? hapticService.playPattern(pattern: pattern)
            }
            soundRepo.startEnemyGameOverSound()
            
            if config.ttsEnabled {
                ttsService.speak(config.ttsMessages.defeat, priority: .high)
            }
        } else {
            soundRepo.playVictorySound()
            
            if config.ttsEnabled {
                ttsService.speak(config.ttsMessages.victory, priority: .high)
            }
        }

        soundRepo.stopEnvironmentSound()
        soundRepo.stopEnemyRunningSound()
    }
    
    func stepsGoalGameOverHandler() {
        if steps >= stepGoal {
            gameOverCallback(true)
        }
    }
    
    func restart() {
        dispose()
        
        steps = 0
        speed = 0
        distance = 0
        stepsPerSecond = 0
        isGameOver = false
        stepGoalReached = false
        enemyCloseness = 0
        hasActiveEnemy = false
        lastSpokenStepsRemaining = nil
        lastEnemyWarningLevel = 0
        
        enemiesRepo.configure(with: config.enemies)
        try? hapticService.restart()
        stepHaptic = try? HapticsPatterns.getHapticPlayerFromPattern(
            pattern: HapticsPatterns.getStepPattern(),
            engine: hapticService.engine
        )
        
        gameTask = Task {
            try await startGame()
        }
    }
    
    func dispose() {
        gameTask?.cancel()
        gameTask = nil
        stopEnemyTick()
        hapticService.dispose()
        stepsRepo.stop()
        soundRepo.dispose()
        ttsService.stop()
        try? stepHaptic?.cancel()
        stepHaptic = nil
        enemiesRepo.reset()
    }
    
    func initialize() async throws {
        stepsRepo.strideLength = config.effectiveStrideLength
        stepsRepo.start()
        
        soundRepo.initialize(with: config.audio)
        enemiesRepo.enemyAudioPlayer = soundRepo.enemyAudio
        
        try hapticService.initEngine()
        stepHaptic = try? HapticsPatterns.getHapticPlayerFromPattern(
            pattern: HapticsPatterns.getStepPattern(),
            engine: hapticService.engine
        )
        
        try? await Task.sleep(for: .seconds(2))
        if stepsRepo.stepsStream == nil {
            throw StepsError.streamError
        }
        
        soundRepo.playEnvironmentSound()
    }

    private func startEnemyTick() {
        stopEnemyTick()
        enemyTickTask = Task { @MainActor [weak self] in
            while let self, !Task.isCancelled {
                if self.isGameOver {
                    break
                }

                self.enemiesRepo.handleEnemyLifeCycle(
                    playerSteps: self.steps,
                    playerStepsPerSecond: Double(self.stepsPerSecond),
                    difficulty: self.config.level.difficulty,
                    gameOverCallback: { [weak self] didWin in
                        self?.gameOverCallback(didWin)
                    },
                    soundRepo: self.soundRepo
                )

                self.hasActiveEnemy = self.enemiesRepo.enemy != nil
                self.enemyCloseness = self.enemiesRepo.getEnemyCloseness(playerSteps: self.steps)

                try? await Task.sleep(nanoseconds: 100_000_000) // 10Hz
            }
        }
    }

    private func stopEnemyTick() {
        enemyTickTask?.cancel()
        enemyTickTask = nil
    }
    
    var stepsRemaining: Int {
        max(0, stepGoal - Int(steps))
    }
    
    var progress: Double {
        guard stepGoal > 0 else { return 0 }
        return min(1.0, Double(steps) / Double(stepGoal))
    }
    
    var levelName: String {
        config.level.name
    }
    
    var theme: LevelTheme? {
        config.theme
    }
}

enum StepsError: Error {
    case streamError
}
