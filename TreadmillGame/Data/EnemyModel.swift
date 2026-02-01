import Foundation

class EnemyModel {
    var startStep : Int // the step number in which the enemy will be deployed
    var maxSteps  : Int // the max number of steps that the enemy can walk or run
    var stepsPerSecond : Double // enemy speed
    var  startedAt : Date! // deploy time
    
    init(startStep: Int, maxSteps: Int, stepsPerSecond : Double) {
        self.startStep = startStep
        self.maxSteps = maxSteps
        self.stepsPerSecond = stepsPerSecond
    }
    
    func setDate(date : Date) {
        self.startedAt = date
    }
}
