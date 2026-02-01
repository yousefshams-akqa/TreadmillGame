
struct StepsResult : Hashable {
    var steps : Int64
    var speed : Double
    var distance : Double
    var stepsPerSecond : Int
    var hasStoppedMoving : Bool

    init(steps: Int64, speed: Double, distance: Double, hasStoppedMoving : Bool, stepsPerSecond : Int) {
        self.steps = steps
        self.speed = speed
        self.distance = distance
        self.stepsPerSecond = stepsPerSecond
        self.hasStoppedMoving = hasStoppedMoving
    }
    
    func toString() -> String {
        let separator = "***********************"
        return "Steps: \(steps)\nSpeed: \(speed) km/h\nDistance: \(distance) km\nSteps Per Second: \(stepsPerSecond)\nHas Stopped Moving: \(hasStoppedMoving)\n\(separator)"
    }
}
