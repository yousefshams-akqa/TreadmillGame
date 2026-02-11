import SwiftUI

/// Displays all game stats (speed, distance, pace) in a horizontal layout
struct StatsView: View {
    let speed: Double
    let distance: Double
    let stepsPerSecond: Int
    
    var body: some View {
        HStack(spacing: AppSpacing.horizontalPadding) {
            StatView(
                label: AppText.Stats.speed,
                value: String(format: "%.1f km/h", speed)
            )
            
            StatView(
                label: AppText.Stats.distance,
                value: String(format: "%.2f km", distance)
            )
            
            StatView(
                label: AppText.Stats.pace,
                value: "\(stepsPerSecond) sps"
            )
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.xl) {
        StatsView(speed: 8.5, distance: 1.23, stepsPerSecond: 12)
        StatsView(speed: 10.2, distance: 2.47, stepsPerSecond: 15)
        StatsView(speed: 5.1, distance: 0.52, stepsPerSecond: 8)
    }
    .padding()
}
