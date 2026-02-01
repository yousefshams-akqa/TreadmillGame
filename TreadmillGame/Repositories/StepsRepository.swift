import CoreMotion

class StepsRepository {
    var stepsStream : AsyncStream<StepsResult>!
    var streamContinuation : AsyncStream<StepsResult>.Continuation!
    private let motionManager : CMMotionManager
    private let queue = OperationQueue()
    var steps: Int64 = 0
    private var buffer : [Double] = []
    private var lastStepTime : TimeInterval = TimeInterval(0)
    private var aboveThreshold = false
    private var peakMagnitude : Double = 0
    private var firstStepTime : Date?
    
    private var strideLength = 1.75 * 0.415
    var hasStoppedMoving : Bool = false
    
    private let SAMPLE_RATE = 50
    private let STEP_THRESHOLD = 1.15      // acceleration magnitude (in g)
    private let MIN_STEP_INTERVAL = 0.3    // seconds (300 ms)
    private let SMOOTHING_WINDOW = 5       // samples
    private let MAX_RECENT_STEPS = 3
    private let SECONDS_STOPPED_WINDOW = 2
    
    private var recentStepTimes : [TimeInterval] = []
    var isStreamReady : Bool = false
    var lastStepResult : StepsResult!
    
    static var instance : StepsRepository = StepsRepository(motionManager: CMMotionManager())
    
    
    
    private init(motionManager: CMMotionManager) {
        self.motionManager = motionManager
    }


    func start() {
        reset()
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 50.0
            stepsStream = AsyncStream { continuation in
                streamContinuation = continuation
                motionManager.startAccelerometerUpdates(to: queue, withHandler: accelometerHandler)
            }
        }
    }
    
    func stop() {
        reset()
    }
    
    
    private func reset() {
        lastStepTime = 0.0
        buffer.removeAll()
        steps = 0
        aboveThreshold = false
        peakMagnitude = 0
        queue.cancelAllOperations()
        motionManager.stopAccelerometerUpdates()
        stepsStream = nil
    }
    
    private func accelometerHandler (data : CMAccelerometerData?, error: Error?) {
        if error != nil {
            return
        }
        
        guard let data else {
            return
        }
        
        let isStep = isAStep(data: data)
        
        if isStep {
            let stepsResult = calculateStepsResult()
            lastStepResult = stepsResult
            streamContinuation.yield(stepsResult)
            print(stepsResult.toString())
        }
        
        if recentStepTimes.count > 1 {
            let timeDiff = Date.now.timeIntervalSince1970 - (recentStepTimes.last ?? 0.0)
            hasStoppedMoving = timeDiff > Double(SECONDS_STOPPED_WINDOW)
            streamContinuation.yield(StepsResult(steps: steps, speed: 0, distance: lastStepResult.distance, hasStoppedMoving: hasStoppedMoving))
        }
    }
    
    private func calculateStepsResult() -> StepsResult {
        var speed = 0.0
        var distance = 0.0
        
        steps += 1
        lastStepTime = Date.now.timeIntervalSince1970
        firstStepTime = steps == 1 ? Date.now : firstStepTime
        
        if recentStepTimes.count >= MAX_RECENT_STEPS {
            recentStepTimes.removeFirst()
        }
        recentStepTimes.append(Date.now.timeIntervalSince1970)

        if recentStepTimes.count >= 2 {
            let timeDifference = (recentStepTimes.last ?? 0.0) - (recentStepTimes.first ?? 0.0)
            let numberOfSteps = Double(recentStepTimes.count - 1)
            if timeDifference > 0 {
                speed = numberOfSteps / Double(timeDifference) * strideLength
                distance = Double(steps) * strideLength / 1000
            }
        }
        
        return StepsResult(steps: steps, speed: speed, distance: distance, hasStoppedMoving: false)
    }
    
    private func isAStep(data : CMAccelerometerData) -> Bool {
        var isStep = false
        let x = data.acceleration.x
        let y = data.acceleration.y
        let z = data.acceleration.z
        
        let magnitude = sqrt(x*x + y*y + z*z)
        
        buffer.append(magnitude)
        
        if buffer.count > SMOOTHING_WINDOW {
            buffer.removeFirst()
        }
        
        var total : Double = 0
        for item in buffer {
            total += item
        }
        let smoothMag = total / Double(buffer.count)

        
        // 3) Peak detection - detect rise AND fall pattern
        if smoothMag > STEP_THRESHOLD {
            aboveThreshold = true
            peakMagnitude = max(peakMagnitude, smoothMag)
        } else if aboveThreshold {
            // Falling edge - we've completed a peak
            aboveThreshold = false
            let timeSinceLastStep = Date.now.timeIntervalSince1970 - lastStepTime
            if timeSinceLastStep > MIN_STEP_INTERVAL && peakMagnitude > STEP_THRESHOLD {
                isStep = true
            }
            peakMagnitude = 0
        }
        return isStep
    }
 }
