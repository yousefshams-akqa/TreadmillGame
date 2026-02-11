import SwiftUI

/// Displays a single stat with label and value
struct StatView: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(value)
                .font(AppFonts.headline(weight: .bold))
            
            Text(label)
                .font(AppFonts.caption())
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    HStack(spacing: AppSpacing.horizontalPadding) {
        StatView(label: "Speed", value: "8.5 km/h")
        StatView(label: "Distance", value: "1.23 km")
        StatView(label: "Pace", value: "12 sps")
    }
    .padding()
}
