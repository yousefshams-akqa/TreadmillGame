import Foundation
import SwiftUI
import CoreHaptics
import AVFAudio

class EnemiesRepository {
    
    var enemy: EnemyModel?
    
    /// Enemy configurations from the level, sorted by spawn step
    private var enemyConfigs: [EnemyConfig]
    
    /// Index of the next enemy to deploy
    private var nextEnemyIndex: Int = 0

    /// Timestamp for when the enemy first reached/passed the player (used for time-grace catch).
    private var catchStartedAt: Date?
    
    let hapticService: HapticsService
    var enemyPlayer: CHHapticAdvancedPatternPlayer!
    var enemyAudioPlayer: AVAudioPlayer?
    private var lastClosenessValue: Float = -1.0 // Track last value to avoid unnecessary updates

    init(hapticService: HapticsService, enemyConfigs: [EnemyConfig] = []) {
        self.hapticService = hapticService
        self.enemyConfigs = enemyConfigs.sorted { $0.spawnAtStep < $1.spawnAtStep }
    }
    /// Configure enemies for a new game session
    func configure(with configs: [EnemyConfig]) {
        self.enemyConfigs = configs.sorted { $0.spawnAtStep < $1.spawnAtStep }
        self.nextEnemyIndex = 0
        self.enemy = nil
        self.lastClosenessValue = -1.0
        self.catchStartedAt = nil
    }
    
    /// Get the current enemy config (if an enemy is active)
    var currentEnemyConfig: EnemyConfig? {
        guard enemy != nil, nextEnemyIndex > 0 else { return nil }
        return enemyConfigs[nextEnemyIndex - 1]
    }
    
    func deployEnemy(config: EnemyConfig) {
        print("[EnemiesRepo] Deploying enemy - startStep: \(config.spawnAtStep), maxSteps: \(config.maxSteps), stepsPerSecond: \(config.stepsPerSecond)")
        let deployedEnemy = EnemyModel(
            startStep: config.spawnAtStep,
            maxSteps: config.maxSteps,
            stepsPerSecond: config.stepsPerSecond
        )
        deployedEnemy.setDate(date: Date.now)
        enemy = deployedEnemy
        catchStartedAt = nil
        print("[EnemiesRepo] Enemy deployed at time: \(Date.now)")
    }

    func destoryEnemy() {
        print("[EnemiesRepo] Destroying enemy")
        enemy = nil
        catchStartedAt = nil
        try? enemyPlayer?.stop(atTime: 0)
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

    
    func handleEnemyLifeCycle(
        playerSteps: Int64,
        playerStepsPerSecond: Double,
        difficulty: Difficulty,
        gameOverCallback: (Bool) -> Void,
        soundRepo: SoundRepository
    ) {
        print("[EnemiesRepo] handleEnemyLifeCycle - playerSteps: \(playerSteps), hasEnemy: \(enemy != nil)")
        if let enemy {
            print("[EnemiesRepo] Speed check - playerSPS: \(String(format: "%.2f", playerStepsPerSecond)), enemySPS: \(String(format: "%.2f", enemy.stepsPerSecond))")
        }
        
        // Check if a new enemy should spawn (even if one is already active)
        if shouldSpawnNextEnemy(playerSteps: playerSteps) {
            print("[EnemiesRepo] Next enemy spawn step reached - destroying current enemy to spawn new one")
            destoryEnemy()
            pauseHaptics()
            soundRepo.stopEnemyRunningSound()
            spawnNextEnemy(playerSteps: playerSteps, playerStepsPerSecond: playerStepsPerSecond, difficulty: difficulty, soundRepo: soundRepo)
            return
        }
        
        if enemy == nil {
            handleEmptyEnemies(playerSteps: playerSteps, playerStepsPerSecond: playerStepsPerSecond, difficulty: difficulty, soundRepo: soundRepo)
            return
        }
        handleEnemies(playerSteps: playerSteps, difficulty: difficulty, gameOverCallback: gameOverCallback, soundRepo: soundRepo)
    }
    
    /// Check if the next enemy should spawn based on player steps
    private func shouldSpawnNextEnemy(playerSteps: Int64) -> Bool {
        guard enemy != nil else { return false } // Only relevant when an enemy is active
        guard nextEnemyIndex < enemyConfigs.count else { return false }
        
        let nextConfig = enemyConfigs[nextEnemyIndex]
        return nextConfig.spawnAtStep <= playerSteps
    }
    
    /// Spawn the next enemy in the queue
    private func spawnNextEnemy(
        playerSteps: Int64,
        playerStepsPerSecond: Double,
        difficulty: Difficulty,
        soundRepo: SoundRepository
    ) {
        guard nextEnemyIndex < enemyConfigs.count else { return }
        
        let nextConfig = enemyConfigs[nextEnemyIndex]
        nextEnemyIndex += 1
        print("[EnemiesRepo] Spawning next enemy at step: \(nextConfig.spawnAtStep)")
        deployEnemy(config: effectiveEnemyConfig(from: nextConfig, playerStepsPerSecond: playerStepsPerSecond, difficulty: difficulty))
        initHaptics()
        soundRepo.startEnemyStartSound()
        soundRepo.startEnemyRunningSound()
    }
    
    private func handleEmptyEnemies(
        playerSteps: Int64,
        playerStepsPerSecond: Double,
        difficulty: Difficulty,
        soundRepo: SoundRepository
    ) {
        print("[EnemiesRepo] handleEmptyEnemies - playerSteps: \(playerSteps), nextEnemyIndex: \(nextEnemyIndex), totalEnemies: \(enemyConfigs.count)")
        
        guard nextEnemyIndex < enemyConfigs.count else {
            print("[EnemiesRepo] No more enemies to deploy")
            return
        }
        
        let nextConfig = enemyConfigs[nextEnemyIndex]
        print("[EnemiesRepo] Checking next enemy spawn at step: \(nextConfig.spawnAtStep) vs playerSteps: \(playerSteps)")
        
        if nextConfig.spawnAtStep <= playerSteps {
            nextEnemyIndex += 1
            print("[EnemiesRepo] Condition met! Deploying new enemy at startStep: \(nextConfig.spawnAtStep)")
            deployEnemy(config: effectiveEnemyConfig(from: nextConfig, playerStepsPerSecond: playerStepsPerSecond, difficulty: difficulty))
            initHaptics()
            soundRepo.startEnemyStartSound()
            soundRepo.startEnemyRunningSound()
        } else {
            print("[EnemiesRepo] Condition not met - waiting for player to reach step \(nextConfig.spawnAtStep)")
        }
    }
    
    private func handleEnemies(
        playerSteps: Int64,
        difficulty: Difficulty,
        gameOverCallback: (Bool) -> Void,
        soundRepo: SoundRepository
    ) {
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
        if shouldDestroyEnemyBecausePlayerEscaped(enemySteps: enemySteps, playerSteps: playerSteps, difficulty: difficulty) {
            print("[EnemiesRepo] Player escaped enemy by enough steps - destroying enemy")
            destoryEnemy()
            pauseHaptics()
            soundRepo.stopEnemyRunningSound()
            return
        }
        if isGameOver(enemySteps: enemySteps, playerSteps: playerSteps, difficulty: difficulty) {
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
            enemyPlayer?.loopEnabled = true
            try? enemyPlayer?.start(atTime: 0)
            print("[EnemiesRepo] enemyPlayer started with looping enabled")
        }
        else {
            print("[EnemiesRepo] Seeking existing enemyPlayer to offset 0")
            try? enemyPlayer?.seek(toOffset: 0)
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

    private func isGameOver(enemySteps: Double, playerSteps: Int64, difficulty: Difficulty) -> Bool {
        let playerStepsDouble = Double(playerSteps)

        // If the player is still ahead, reset the grace timer.
        if enemySteps < playerStepsDouble {
            catchStartedAt = nil
            return false
        }

        else {
            // Enemy has reached/passed the player: start (or continue) the grace timer.
            if catchStartedAt == nil {
                catchStartedAt = Date.now
                return false
            }

            let configuredGrace = currentEnemyConfig?.catchMarginSeconds ?? 0
            let effectiveGraceSeconds = max(configuredGrace, difficulty.minCatchGraceSeconds)
            let elapsed = Date.now.timeIntervalSince(catchStartedAt ?? Date.now)
            return elapsed >= effectiveGraceSeconds
        }
    }
    
    private func shouldDestroyEnemyBecausePlayerEscaped(
        enemySteps: Double,
        playerSteps: Int64,
        difficulty: Difficulty
    ) -> Bool {
        let lead = Double(playerSteps) - enemySteps
        let profile = DifficultyProfile.resolve(for: difficulty)
        return lead >= profile.escapeDistanceSteps
    }

    private func effectiveEnemyConfig(from config: EnemyConfig, playerStepsPerSecond: Double, difficulty: Difficulty) -> EnemyConfig {
        // No adaptive speed on easy.
        guard !difficulty.isEasy else { return config }

        let playerSps = max(playerStepsPerSecond, 0.1)
        let hybridSps = (0.5 * playerSps) + (0.5 * config.stepsPerSecond)
        let effectiveSps = max(config.stepsPerSecond, hybridSps)
        return EnemyConfig(
            spawnAtStep: config.spawnAtStep,
            maxSteps: config.maxSteps,
            stepsPerSecond: effectiveSps,
        )
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
    /// Only sends parameters if closeness changed by at least 0.15 from last update
    func updateEnemyEffectsForCloseness(playerSteps: Int64) {
        guard let enemyPlayer else { return }
        
        let closeness = getEnemyCloseness(playerSteps: playerSteps)
        
        // Only update if difference is at least 0.15
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
    
    /// Reset the repository for a new game
    func reset() {
        enemy = nil
        nextEnemyIndex = 0
        lastClosenessValue = -1.0
        catchStartedAt = nil
        try? enemyPlayer?.cancel()
        enemyPlayer = nil
    }
}
