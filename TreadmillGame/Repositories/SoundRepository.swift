import AVFAudio

class SoundRepository {
    
    var enemyStartAudio: AVAudioPlayer!
    var enemyAudio: AVAudioPlayer!
    var environmentAudio: AVAudioPlayer!
    var enemyGameOverAudio: AVAudioPlayer!
    var victoryAudio: AVAudioPlayer!
    
    /// The audio configuration for the current level
    private var audioConfig: LevelAudio?
    
    /// Initialize with default (bundled) audio - for backwards compatibility
    func initialize() {
        // Use default bundled audio files
        let defaultConfig = LevelAudio(
            environmentSound: .bundled("winter_wind_sound.mp3"),
            enemySpawnSound: .bundled("enemy_start_sound.mp3"),
            enemyRunningSound: .bundled("enemy_running_sound.mp3"),
            enemyGameOverSound: .bundled("enemy_game_over_sound.mp3"),
            victorySound: .bundled("victory_sound.mp3")
        )
        initialize(with: defaultConfig)
    }
    
    /// Initialize with a specific audio configuration from a level
    func initialize(with config: LevelAudio) {
        self.audioConfig = config
        
        do {
            environmentAudio = try loadAudioPlayer(from: config.environmentSound)
            enemyStartAudio = try loadAudioPlayer(from: config.enemySpawnSound)
            enemyAudio = try loadAudioPlayer(from: config.enemyRunningSound)
            enemyGameOverAudio = try loadAudioPlayer(from: config.enemyGameOverSound)
            victoryAudio = try loadAudioPlayer(from: config.victorySound)

            environmentAudio.numberOfLoops = Int.max
            enemyAudio.numberOfLoops = Int.max
            
            environmentAudio.prepareToPlay()
            enemyStartAudio.prepareToPlay()
            enemyAudio.prepareToPlay()
            enemyGameOverAudio.prepareToPlay()
            victoryAudio.prepareToPlay()
        }
        catch {
            print("[SoundRepository] Audio initialization error: \(error)")
        }
    }
    
    /// Load an audio player from an AudioSource
    private func loadAudioPlayer(from source: AudioSource) throws -> AVAudioPlayer {
        guard let url = source.resolveURL() else {
            throw AudioError.fileNotFound(source.value)
        }
        
        do {
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            throw AudioError.loadFailed(source.value, error)
        }
    }
    
    // MARK: - Environment Sound
    
    func playEnvironmentSound() {
        environmentAudio?.play()
    }
    
    func stopEnvironmentSound() {
        environmentAudio?.stop()
    }
    
    // MARK: - Enemy Sounds
    
    func startEnemyStartSound() {
        enemyStartAudio?.play()
    }
    
    func startEnemyRunningSound() {
        enemyAudio?.play()
    }
    
    func stopEnemyRunningSound() {
        enemyAudio?.stop()
    }
    
    func startEnemyGameOverSound() {
        enemyGameOverAudio?.play()
    }
    
    // MARK: - Victory Sound
    
    func playVictorySound() {
        victoryAudio?.play()
    }
    
    // MARK: - Cleanup
    
    func dispose() {
        environmentAudio?.stop()
        enemyStartAudio?.stop()
        enemyAudio?.stop()
        victoryAudio?.stop()
        enemyGameOverAudio?.stop()
    }
}

/// Errors that can occur when loading audio
enum AudioError: Error, LocalizedError {
    case fileNotFound(String)
    case loadFailed(String, Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "Audio file not found: \(name)"
        case .loadFailed(let name, let error):
            return "Failed to load audio '\(name)': \(error.localizedDescription)"
        }
    }
}