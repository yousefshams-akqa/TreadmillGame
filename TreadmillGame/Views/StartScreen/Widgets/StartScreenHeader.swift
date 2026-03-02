import SwiftUI
import Lottie

struct StartScreenHeader: View {
    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            LottieView {
                await LottieAnimation.loadedFrom(url: URL(string:"https://lottie.host/8935aae4-7ac7-47b9-8170-bcd24d9bcd24/DSkuv45pet.json")! )
            }.playing()
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
