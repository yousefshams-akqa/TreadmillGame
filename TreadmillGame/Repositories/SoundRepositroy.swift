import AVFAudio

class SoundRepositroy {
    
    var enemyStartAudio : AVAudioPlayer!
    var enemyAudio : AVAudioPlayer!
    var environmentAudio : AVAudioPlayer!
    var enemyGameOverAudio : AVAudioPlayer!
    var victoryAudio : AVAudioPlayer!
    
    func initialize() {
        do {
            environmentAudio = try AVAudioPlayer.init(contentsOf: Bundle.main.url(forResource: "winter_wind_sound.mp3" , withExtension: nil)!)
            enemyStartAudio = try AVAudioPlayer.init(contentsOf: Bundle.main.url(forResource: "enemy_start_sound.mp3" , withExtension: nil)!)
            enemyAudio = try AVAudioPlayer.init(contentsOf: Bundle.main.url(forResource: "enemy_running_sound.mp3" , withExtension: nil)!)
            enemyGameOverAudio = try AVAudioPlayer.init(contentsOf: Bundle.main.url(forResource: "enemy_game_over_sound.mp3" , withExtension: nil)!)
            victoryAudio = try AVAudioPlayer.init(contentsOf: Bundle.main.url(forResource: "victory_sound.mp3" , withExtension: nil)!)

            environmentAudio.numberOfLoops = Int.max
            enemyAudio.numberOfLoops = Int.max
            
            environmentAudio.prepareToPlay()
            enemyStartAudio.prepareToPlay()
            enemyAudio.prepareToPlay()
            enemyGameOverAudio.prepareToPlay()
            victoryAudio.prepareToPlay()
        }
        catch {
            print("Audio error: \(error)")
        }
    }
    
    func playEnvironmentSound() {
        environmentAudio.play()
    }
    
    
    func stopEnvironmentSound() {
        environmentAudio.stop()
    }
    
    func startEnemyStartSound() {
        enemyStartAudio.play()
    }
    
    func startEnemyRunningSound() {
        enemyAudio.play()
    }
    
    func stopEnemyRunningSound() {
        enemyAudio.stop()
    }
    
    func startEnemyGameOverSound() {
        enemyGameOverAudio.play()
    }
    
    func playVictorySound() {
        victoryAudio.play()
    }
    
    func dispose() {
        environmentAudio.stop()
        enemyStartAudio.stop()
        enemyAudio.stop()
        victoryAudio.stop()
    }
}
