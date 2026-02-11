import SwiftUI

struct StartScreenHeader: View {
    var body: some View {
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

#Preview {
    StartScreenHeader().padding()
}
