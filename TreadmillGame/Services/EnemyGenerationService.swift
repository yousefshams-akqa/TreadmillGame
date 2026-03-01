import Foundation

/// Generates enemy configurations from level metadata.
/// This keeps JSON compact while preserving difficulty-aware progression.
struct EnemyGenerationService {
    private static let minimumEnemyCount = 6
    private static let maximumEnemyCount = 100
    
    static func generate(for level: Level) -> [EnemyConfig] {
        if let staticEnemies = level.enemies, !staticEnemies.isEmpty {
            return staticEnemies.sorted { $0.spawnAtStep < $1.spawnAtStep }
        }
        
        let count = determineEnemyCount(for: level)
        guard count > 0 else { return [] }
        
        let profile = DifficultyProfile.resolve(for: level.difficulty)
        let startSpawn = Int((Double(level.stepGoal) * EnemyConfig.spawnStartRatio).rounded())
        let endSpawn = Int((Double(level.stepGoal) * EnemyConfig.spawnEndRatio).rounded())
        
        var configs: [EnemyConfig] = []
        configs.reserveCapacity(count)
        
        var lastSpawnStep = max(0, startSpawn - 1)
        for index in 0..<count {
            let progress = count == 1 ? 1.0 : Double(index) / Double(count - 1)
            
            let spawnProgress = pow(progress, 0.7)
            var spawnAtStep = Int(interpolate(
                from: Double(startSpawn),
                to: Double(endSpawn),
                progress: spawnProgress
            ).rounded())
            spawnAtStep = max(lastSpawnStep + 1, spawnAtStep)
            spawnAtStep = min(endSpawn, spawnAtStep)
            lastSpawnStep = spawnAtStep
            
            let maxSteps = Int(interpolate(
                from: profile.maxStepsMin,
                to: profile.maxStepsMax,
                progress: pow(progress, 0.9)
            ).rounded())
            
            let stepsPerSecond = roundToPlaces(
                interpolate(
                    from: profile.spsMin,
                    to: profile.spsMax,
                    progress: pow(progress, 1.15)
                ),
                places: 2
            )
            
            configs.append(
                EnemyConfig(
                    spawnAtStep: spawnAtStep,
                    maxSteps: maxSteps,
                    stepsPerSecond: stepsPerSecond,
                )
            )
        }
        
        return configs
    }
    
    private static func determineEnemyCount(for level: Level) -> Int {
        if let explicit = level.enemyCount {
            return clampToRange(explicit, min: minimumEnemyCount, max: maximumEnemyCount)
        }
        
        let profile = DifficultyProfile.resolve(for: level.difficulty)
        let density = profile.enemyDensityPerThousandSteps
        let derived = Int((Double(level.stepGoal) / 1000.0 * density).rounded())
        return clampToRange(derived, min: minimumEnemyCount, max: maximumEnemyCount)
    }
    
    private static func clampToRange<T: Comparable>(_ value: T, min minValue: T, max maxValue: T) -> T {
        Swift.min(maxValue, Swift.max(minValue, value))
    }
    
    private static func interpolate(from: Double, to: Double, progress: Double) -> Double {
        from + ((to - from) * progress)
    }
    
    private static func roundToPlaces(_ value: Double, places: Int) -> Double {
        let factor = pow(10.0, Double(places))
        return (value * factor).rounded() / factor
    }
}
