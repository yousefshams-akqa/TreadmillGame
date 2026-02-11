import SwiftUI

struct ContinueButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(AppText.StartScreen.continueButton)
                .font(AppFonts.headline(weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: AppSizes.cornerRadiusLarge)
                        .fill(isEnabled ? AppColors.primary : AppColors.secondary)
                )
        }
        .disabled(!isEnabled)
        .padding(.top, AppSpacing.xl)
    }
}

#Preview {
    VStack(spacing: 20) {
        ContinueButton(isEnabled: true, action: {})
        ContinueButton(isEnabled: false, action: {})
    }
    .padding()
}
