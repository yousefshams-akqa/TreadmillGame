import CoreHaptics

class HapticsService {
    
    var supportsHaptics: Bool = false
    var engine: CHHapticEngine!
    var isInit : Bool = false
    var isPlayerFinished : Bool = false

    func initEngine() throws {
        if isInit {
            return
        }
        
        // Check if the device supports haptics.
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics
        
        if !supportsHaptics {
            print("Haptic feedback is not supported")
            return
        }
        
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        
        engine.resetHandler = resetHandler
        engine.stoppedHandler = stoppedHandler
        
        engine.notifyWhenPlayersFinished { error in
            self.isPlayerFinished = true
            return .leaveEngineRunning
        }

        try engine.start()
        isInit = true
    }
    
    func playPattern(pattern: CHHapticPattern) throws {
        let player = try HapticsPatterns.getHapticPlayerFromPattern(pattern: pattern, engine: engine)
        try player.start(atTime: 0)
    }

    
    
    func resetHandler() {
        print("Reset Handler: Restarting the engine.")
        
        do {
            // Try restarting the engine.
            try self.engine.start()
                    
            // Register any custom resources you had registered, using registerAudioResource.
            // Recreate all haptic pattern players you had created, using createPlayer.
        } catch {
            fatalError("Failed to restart the engine: \(error)")
        }
    }
    
    func stoppedHandler(reason : CHHapticEngine.StoppedReason) {
        print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
        switch reason {
        case .audioSessionInterrupt: print("Audio session interrupt")
        case .applicationSuspended: print("Application suspended")
        case .idleTimeout: print("Idle timeout")
        case .systemError: print("System error")
        case .notifyWhenFinished:
            print("notifyWhenFinished")
        case .engineDestroyed:
            print("engineDestroyed")
        case .gameControllerDisconnect:
            print("gameControllerDisconnect")
        @unknown default:
            print("Unknown error")
        }
    }
    
    func dispose() {
        engine.stop()
    }
}


enum HapticErrors : Error {
    case patternCreationError
    case playerCreationError
}
