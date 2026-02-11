import SwiftUI

struct FormField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(label)
                .font(AppFonts.subheadline(weight: .medium))
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(AppSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppSizes.cornerRadiusMedium)
                        .fill(AppColors.Background.secondary)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppSizes.cornerRadiusMedium)
                        .stroke(Color.gray.opacity(0.2), lineWidth: AppSizes.borderThin)
                )
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.lg) {
        FormField(label: "Name", text: .constant(""), placeholder: "Your name")
        FormField(label: "Age", text: .constant("25"), placeholder: "Your age", keyboardType: .numberPad)
    }
    .padding()
}
