import SwiftUI

struct ProgressSectionView: View {
    let progress: Float
    let steps: Int
    let stepGoal: Int
    let progressColor: Color
    
    private var remaining: Int {
        max(0, stepGoal - steps)
    }
    
    var body: some View {
        let cornerRadius = AppSizes.progressBarHeightLarge / 2
        VStack(spacing: AppSpacing.md) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.gray.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(progressColor)
                        .frame(width: geometry.size.width * CGFloat(min(1, progress)))
                        .animation(.easeOut(duration: 0.2), value: progress)
                }
            }
            .frame(height: AppSizes.progressBarHeightLarge)
            
            HStack {
                Text("\(steps) \(AppText.Stats.stepsUnit)")
                    .font(AppFonts.headline(weight: .semibold))
                
                Spacer()
                
                Text("\(remaining) \(AppText.Stats.toGo)")
                    .font(AppFonts.subheadline())
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, AppSpacing.horizontalPadding)
    }
}

#Preview {
    VStack(spacing: AppSpacing.xl) {
        ProgressSectionView(
            progress: 0.3,
            steps: 150,
            stepGoal: 500,
            progressColor: .blue
        )
        
        ProgressSectionView(
            progress: 0.7,
            steps: 350,
            stepGoal: 500,
            progressColor: .orange
        )
        
        ProgressSectionView(
            progress: 1.0,
            steps: 500,
            stepGoal: 500,
            progressColor: .green
        )
    }
    .padding()
}
