import SwiftUI
import Lottie

struct StartScreenHeader: View {
    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            LottieView(animation: .asset("treadmill")).playing(loopMode: .loop)
                .frame(maxWidth: 70, maxHeight: 70)
            
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(AppText.StartScreen.title)
                    .font(AppFonts.largeTitle())
                
                Text(AppText.StartScreen.subtitle)
                    .font(AppFonts.body())
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    StartScreenHeader().padding()
}
