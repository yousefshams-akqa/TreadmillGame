import CoreHaptics

class HapticsPatterns {
    static let shared = HapticsPatterns()
    
    private init() {}
    
    static func getGrassHapticPattern() throws -> CHHapticPattern {
        var events: [CHHapticEvent] = []
            var currentTime: TimeInterval = 0

            let baseInterval: TimeInterval = 0.5 // walking pace (~120 steps/min)

            for _ in 0..<20 { // 20 steps loop

                let thudIntensity = CHHapticEventParameter(
                    parameterID: .hapticIntensity,
                    value: Float.random(in: 0.5...0.65)
                )

                let thudSharpness = CHHapticEventParameter(
                    parameterID: .hapticSharpness,
                    value: Float.random(in: 0.25...0.35)
                )

                let thud = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [thudIntensity, thudSharpness],
                    relativeTime: currentTime
                )

                // micro texture right after
                let textureIntensity = CHHapticEventParameter(
                    parameterID: .hapticIntensity,
                    value: Float.random(in: 0.2...0.3)
                )

                let textureSharpness = CHHapticEventParameter(
                    parameterID: .hapticSharpness,
                    value: Float.random(in: 0.6...0.8)
                )

                let texture = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [textureIntensity, textureSharpness],
                    relativeTime: currentTime + 0.03
                )

                events.append(thud)
                events.append(texture)


                // Slight randomness between steps
                currentTime += baseInterval + TimeInterval.random(in: -0.05...0.05)
            }

        return try generatePatternFromEvents(events: events)
        
    }

    /// Creates a haptic pattern simulating an enemy running - fast, heavy footsteps with urgency
    static func getEnemyRunningPattern() throws -> CHHapticPattern {
        var events: [CHHapticEvent] = []
        var currentTime: TimeInterval = 0
        
        let baseInterval: TimeInterval = 0.25 // Running pace (~240 steps/min, much faster than walking)
        let totalSteps = 24
        
        for step in 0..<totalSteps {
            // Calculate intensity that increases slightly over time (enemy getting closer)
            let progressFactor = Float(step) / Float(totalSteps)
            let baseIntensity: Float = 0.6 + (progressFactor * 0.3) // 0.6 -> 0.9
            
            // Heavy foot strike - main impact
            let strikeIntensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: min(baseIntensity + Float.random(in: -0.05...0.1), 1.0)
            )
            
            let strikeSharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: Float.random(in: 0.4...0.6) // Medium-sharp for aggressive feel
            )
            
            let strike = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [strikeIntensity, strikeSharpness],
                relativeTime: currentTime
            )
            
            // Secondary impact - the push-off (lighter but sharp)
            let pushOffIntensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: baseIntensity * 0.5
            )
            
            let pushOffSharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: Float.random(in: 0.7...0.9) // Sharper for the push-off
            )
            
            let pushOff = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [pushOffIntensity, pushOffSharpness],
                relativeTime: currentTime + 0.08
            )
            
            events.append(strike)
            events.append(pushOff)
            
            // Slight randomness to feel organic, but less variation than walking (more urgent/mechanical)
            currentTime += baseInterval + TimeInterval.random(in: -0.02...0.02)
        }
        
        return try generatePatternFromEvents(events: events)
    }
    
    /// Creates a haptic pattern simulating a horse galloping - classic 4-beat rhythm with suspension
    static func getHorseGallopPattern() throws -> CHHapticPattern {
        var events: [CHHapticEvent] = []
        var currentTime: TimeInterval = 0
        
        let gallopCycles = 12 // Number of full gallop cycles
        
        for _ in 0..<gallopCycles {
            // A horse gallop has 4 beats + suspension phase
            // Rhythm: da-da-da-DUM... (pause) da-da-da-DUM...
            
            // Beat 1: First back hoof (medium impact)
            let beat1Intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: Float.random(in: 0.5...0.6)
            )
            let beat1Sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: Float.random(in: 0.5...0.6)
            )
            let beat1 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [beat1Intensity, beat1Sharpness],
                relativeTime: currentTime
            )
            events.append(beat1)
            
            // Beat 2: Second back hoof (medium impact, quick follow)
            let beat2Intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: Float.random(in: 0.45...0.55)
            )
            let beat2Sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: Float.random(in: 0.5...0.6)
            )
            let beat2 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [beat2Intensity, beat2Sharpness],
                relativeTime: currentTime + 0.08
            )
            events.append(beat2)
            
            // Beat 3: First front hoof (slightly heavier)
            let beat3Intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: Float.random(in: 0.55...0.65)
            )
            let beat3Sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: Float.random(in: 0.55...0.65)
            )
            let beat3 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [beat3Intensity, beat3Sharpness],
                relativeTime: currentTime + 0.16
            )
            events.append(beat3)
            
            // Beat 4: Second front hoof - the "landing" (heaviest impact)
            let beat4Intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: Float.random(in: 0.75...0.85)
            )
            let beat4Sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: Float.random(in: 0.4...0.5) // Slightly duller for heavy landing
            )
            let beat4 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [beat4Intensity, beat4Sharpness],
                relativeTime: currentTime + 0.22
            )
            events.append(beat4)
            
            // Suspension phase - move to next cycle
            // Full gallop cycle is ~0.4-0.5 seconds
            currentTime += 0.45 + TimeInterval.random(in: -0.03...0.03)
        }
        
        return try generatePatternFromEvents(events: events)
    }
    
    static func getHapticPlayerFromPattern(pattern: CHHapticPattern, engine: CHHapticEngine) throws -> CHHapticAdvancedPatternPlayer {
        let player = try engine.makeAdvancedPlayer(with: pattern)
        return player
    }
    
    static private func generatePatternFromEvents(events: [CHHapticEvent]) throws -> CHHapticPattern {
        // Create a pattern from the continuous haptic event.
        let pattern = try? CHHapticPattern(events: events, parameters: [])
        
        guard let pattern else {
            throw HapticErrors.patternCreationError
        }
        
        return pattern
    }
    
}
