import Foundation
import CoreHaptics
import AVFAudio

class EnemiesRepository {
    
    var enemy : EnemyModel?
    var startSteps : [Int] = [15, 200 , 500 , 800 , 1200]
    let hapticService : HapticsService
    var enemyPlayer : CHHapticAdvancedPatternPlayer!
    var enemyAudioPlayer: AVAudioPlayer?
    private var lastClosenessValue: Float = -1.0 // Track last value to avoid unnecessary updates

    init(hapticService: HapticsService) {
        self.hapticService = hapticService
    }
    
    func deployEnemy(enemy deployedEnemy : EnemyModel) {
        print("[EnemiesRepo] Deploying enemy - startStep: \(deployedEnemy.startStep), maxSteps: \(deployedEnemy.maxSteps), stepsPerSecond: \(deployedEnemy.stepsPerSecond)")
        deployedEnemy.setDate(date: Date.now)
        enemy = deployedEnemy
        print("[EnemiesRepo] Enemy deployed at time: \(Date.now)")
    }
    
    func destoryEnemy() {
        print("[EnemiesRepo] Destroying enemy")
        enemy = nil
        try? enemyPlayer.stop(atTime: 0)
    }
    
    func getEnemyCurrentSteps() -> Double {
        guard let enemy else {
            return 0
        }
        let timeSinceStart = Date.now.timeIntervalSince1970 - enemy.startedAt.timeIntervalSince1970
        let enemySteps = timeSinceStart * enemy.stepsPerSecond
        let totalSteps = Double(enemy.startStep) + enemySteps
        print("[EnemiesRepo] getEnemyCurrentSteps - timeSinceStart: \(String(format: "%.2f", timeSinceStart))s, enemySteps: \(String(format: "%.2f", enemySteps)), totalSteps: \(String(format: "%.2f", totalSteps))")
        return totalSteps
    }

    func checkIfEnemyRanMaxSteps() -> Bool {
        guard let enemy else {
            print("[EnemiesRepo] checkIfEnemyRanMaxSteps - no enemy present")
            return false
        }
        let enemySteps = getEnemyCurrentSteps()
        let maxStepsThreshold = Double(enemy.startStep + enemy.maxSteps)
        let hasReachedMax = enemySteps >= maxStepsThreshold
        print("[EnemiesRepo] checkIfEnemyRanMaxSteps - enemySteps: \(String(format: "%.2f", enemySteps)), maxThreshold: \(maxStepsThreshold), hasReachedMax: \(hasReachedMax)")
        return hasReachedMax
    }

    
    func handleEnemyLifeCycle(playerSteps: Int64, gameOverCallback: (Bool) -> Void, soundRepo : SoundRepositroy) {
        print("[EnemiesRepo] handleEnemyLifeCycle - playerSteps: \(playerSteps), hasEnemy: \(enemy != nil)")
        if enemy == nil {
            handleEmptyEnemies(playerSteps: playerSteps, soundRepo: soundRepo)
            return
        }
        handleEnemies(playerSteps: playerSteps, gameOverCallback: gameOverCallback, soundRepo : soundRepo)
    }
    
    private func handleEmptyEnemies(playerSteps: Int64, soundRepo : SoundRepositroy) {
        print("[EnemiesRepo] handleEmptyEnemies - playerSteps: \(playerSteps), remainingStartSteps: \(startSteps)")
        if !startSteps.isEmpty {
            let startStep = startSteps.first!
            print("[EnemiesRepo] Checking next startStep: \(startStep) vs playerSteps: \(playerSteps)")
            if startStep <= playerSteps {
                startSteps.removeFirst()
                print("[EnemiesRepo] Condition met! Deploying new enemy at startStep: \(startStep)")
                deployEnemy(enemy: EnemyModel(startStep: startStep, maxSteps: 100, stepsPerSecond: 1))
                initHaptics()
                soundRepo.startEnemyStartSound()
                soundRepo.startEnemyRunningSound()
            } else {
                print("[EnemiesRepo] Condition not met - waiting for player to reach step \(startStep)")
            }
        } else {
            print("[EnemiesRepo] No more enemies to deploy - startSteps is empty")
        }
    }
    
    private func handleEnemies(playerSteps: Int64, gameOverCallback: (Bool) -> Void, soundRepo : SoundRepositroy) {
        print("[EnemiesRepo] handleEnemies - playerSteps: \(playerSteps)")
        
        if checkIfEnemyRanMaxSteps() {
            print("[EnemiesRepo] Enemy ran max steps - destroying enemy")
            destoryEnemy()
            pauseHaptics()
            soundRepo.stopEnemyRunningSound()
            return
        }
        
        let enemySteps = getEnemyCurrentSteps()
        print("[EnemiesRepo] Comparing - enemySteps: \(String(format: "%.2f", enemySteps)) vs playerSteps: \(playerSteps)")
        if isGameOver(enemySteps: enemySteps, playerSteps: playerSteps){
            print("[EnemiesRepo] GAME OVER! Enemy caught the player!")
            pauseHaptics()
            soundRepo.stopEnemyRunningSound()
            gameOverCallback(false)
        } else {
            updateEnemyEffectsForCloseness(playerSteps: playerSteps)
            print("[EnemiesRepo] Player is ahead by \(String(format: "%.2f", Double(playerSteps) - enemySteps)) steps")
        }
    }
    
    private func initHaptics() {
        print("[EnemiesRepo] initHaptics - enemyPlayer exists: \(enemyPlayer != nil)")
        if enemyPlayer == nil {
            print("[EnemiesRepo] Creating new enemyPlayer")
            enemyPlayer = try? HapticsPatterns.getHapticPlayerFromPattern(pattern: HapticsPatterns.getEnemyRunningPattern(), engine: hapticService.engine)
            enemyPlayer.loopEnabled = true
            try? enemyPlayer.start(atTime: 0)
            print("[EnemiesRepo] enemyPlayer started with looping enabled")
        }
        else {
            print("[EnemiesRepo] Seeking existing enemyPlayer to offset 0")
            try? enemyPlayer.seek(toOffset: 0)
        }
    }
    
    private func pauseHaptics() {
        print("[EnemiesRepo] pauseHaptics called")
        guard let enemyPlayer else {
            print("[EnemiesRepo] pauseHaptics - no enemyPlayer to pause")
            return
        }
        do {
            try enemyPlayer.stop(atTime: 0)
            print("[EnemiesRepo] enemyPlayer STOPPED (not just paused)")
        } catch {
            print("[EnemiesRepo] ERROR stopping enemyPlayer: \(error)")
        }
    }

    private func isGameOver(enemySteps : Double, playerSteps: Int64) -> Bool {
        let allowedExtraStepsMargin = 5.0
        return enemySteps >= Double(playerSteps) + allowedExtraStepsMargin
    }
    
    /// Calculates how close the enemy is to the player as a value between 0 and 1
    /// - Parameter playerSteps: Current player step count
    /// - Returns: 1.0 = enemy is at player position (0 steps away), 0.0 = enemy is 25+ steps behind
    func getEnemyCloseness(playerSteps: Int64) -> Float {
        guard enemy != nil else {
            return 0
        }
        
        let enemySteps = getEnemyCurrentSteps()
        let stepsAway = Double(playerSteps) - enemySteps
        
        // Clamp: 0 steps away = 1.0, 25+ steps away = 0.0
        let maxDistance: Double = 25.0
        let closeness = 1.0 - (stepsAway / maxDistance)
        
        return Float(max(0, min(1, closeness)))
    }
    
    /// Updates the enemy haptic player's intensity/sharpness based on current closeness
    /// Only sends parameters if closeness changed by at least 0.2 from last update
    func updateEnemyEffectsForCloseness(playerSteps: Int64) {
        guard let enemyPlayer else { return }
        
        let closeness = getEnemyCloseness(playerSteps: playerSteps)
        
        // Only update if difference is at least 0.2
        guard abs(closeness - lastClosenessValue) >= 0.15 else { return }
        
        lastClosenessValue = closeness
        let parameters = HapticsPatterns.getEnemyClosenessParameters(closeness: closeness)
        print("[EnemiesRepo] Updating haptic parameters: \(parameters.first?.value ?? 0)")
        
        do {
            try enemyPlayer.sendParameters(parameters, atTime: 0)
            
            // Scale volume with closeness (same range as intensity: 0.4 → 1.0)
            let volume: Float = 0.2 + (closeness * 0.8)
            enemyAudioPlayer?.setVolume(volume, fadeDuration: 1)
        } catch {
            print("[EnemiesRepo] Error updating haptic parameters: \(error)")
        }
    }
}
