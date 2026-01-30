
struct StepsResult : Hashable {
    var steps : Int64
    var speed : Double
    var distance : Double
    var hasStoppedMoving : Bool

    init(steps: Int64, speed: Double, distance: Double, hasStoppedMoving : Bool) {
        self.steps = steps
        self.speed = speed
        self.distance = distance
        self.hasStoppedMoving = hasStoppedMoving
    }
    
    func toString() -> String {
        let separator = "***********************"
        return "Steps: \(steps)\nSpeed: \(speed) km/h\nDistance: \(distance) km\nHas Stopped Moving: \(hasStoppedMoving)\n\(separator)"
    }
}
