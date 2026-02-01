import CoreHaptics

class HapticsPatterns {
    static let shared = HapticsPatterns()
    
    private init() {}
    
    /// Creates a simple, quick step haptic - single transient tap, no variations
    /// Designed to be played on-demand with each step
    static func getStepPattern() throws -> CHHapticPattern {
        let intensity = CHHapticEventParameter(
            parameterID: .hapticIntensity,
            value: 1.0
        )
        
        let sharpness = CHHapticEventParameter(
            parameterID: .hapticSharpness,
            value: 0.7
        )
        
        let stepEvent = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity, sharpness],
            relativeTime: 0
        )
        
        return try generatePatternFromEvents(events: [stepEvent])
    }

    /// Creates a haptic pattern simulating an enemy running - fast, heavy footsteps with urgency
    /// Base values are set to 1.0 so dynamic parameters via sendParameters() have full control over intensity/sharpness.
    static func getEnemyRunningPattern() throws -> CHHapticPattern {
        var events: [CHHapticEvent] = []
        var currentTime: TimeInterval = 0
        
        let baseInterval: TimeInterval = 0.25 // Running pace (~240 steps/min, much faster than walking)
        let totalSteps = 24
        
        for _ in 0..<totalSteps {
            // Heavy foot strike - main impact (base at 1.0, controlled by dynamic params)
            let strikeIntensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: 1.0
            )
            
            let strikeSharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: 1.0
            )
            
            let strike = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [strikeIntensity, strikeSharpness],
                relativeTime: currentTime
            )
            
            // Secondary impact - the push-off (lighter, relative to dynamic params)
            let pushOffIntensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: 0.5 // Half of whatever dynamic intensity is applied
            )
            
            let pushOffSharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: 1.0
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
    
    /// Returns dynamic haptic parameters for enemy running based on closeness
    /// - Parameter closeness: 0.0 = far (25+ steps), 1.0 = right behind (0 steps)
    /// - Returns: Array of dynamic parameters to send to a running player
    static func getEnemyClosenessParameters(closeness: Float) -> [CHHapticDynamicParameter] {
        let clampedCloseness = max(0, min(1, closeness))
        
        // Scale intensity and sharpness based on closeness
        // Far: soft & muffled, Close: loud & crisp
        let intensity: Float = 0.4 + (clampedCloseness * 0.6)  // 0.4 → 1.0
        let sharpness: Float = 0.2 + (clampedCloseness * 0.6)  // 0.2 → 0.8
        
        let intensityParam = CHHapticDynamicParameter(
            parameterID: .hapticIntensityControl,
            value: intensity,
            relativeTime: 0
        )
        
        let sharpnessParam = CHHapticDynamicParameter(
            parameterID: .hapticSharpnessControl,
            value: sharpness,
            relativeTime: 0
        )
        
        return [intensityParam, sharpnessParam]
    }
    

    /// Creates a haptic pattern for game over - dramatic impact followed by fading rumble
    static func getGameOverPattern() throws -> CHHapticPattern {
        var events: [CHHapticEvent] = []
        var currentTime: TimeInterval = 0
        
        // Initial heavy impact - the "caught" moment
        let impactIntensity = CHHapticEventParameter(
            parameterID: .hapticIntensity,
            value: 1.0
        )
        let impactSharpness = CHHapticEventParameter(
            parameterID: .hapticSharpness,
            value: 0.3 // Dull, heavy thud
        )
        let impact = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [impactIntensity, impactSharpness],
            relativeTime: currentTime
        )
        events.append(impact)
        
        // Second heavy impact for emphasis
        currentTime += 0.1
        let impact2 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [impactIntensity, impactSharpness],
            relativeTime: currentTime
        )
        events.append(impact2)
        
        // Fading rumble - continuous haptic that dies out
        currentTime += 0.15
        let rumbleDuration: TimeInterval = 0.8
        let rumbleIntensity = CHHapticEventParameter(
            parameterID: .hapticIntensity,
            value: 0.7
        )
        let rumbleSharpness = CHHapticEventParameter(
            parameterID: .hapticSharpness,
            value: 0.2
        )
        let rumble = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [rumbleIntensity, rumbleSharpness],
            relativeTime: currentTime,
            duration: rumbleDuration
        )
        events.append(rumble)
        
        // Intensity curve to fade out the rumble
        let fadeOutCurve = CHHapticParameterCurve(
            parameterID: .hapticIntensityControl,
            controlPoints: [
                CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1.0),
                CHHapticParameterCurve.ControlPoint(relativeTime: rumbleDuration, value: 0.0)
            ],
            relativeTime: currentTime
        )
        
        return try CHHapticPattern(events: events, parameterCurves: [fadeOutCurve])
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
