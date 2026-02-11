import SwiftUI

struct UserFormSection: View {
    @Binding var name: String
    @Binding var age: String
    @Binding var weight: String
    @Binding var height: String
    
    var body: some View {
        VStack(spacing: AppSpacing.fieldSpacing) {
            FormField(
                label: AppText.StartScreen.nameLabel,
                text: $name,
                placeholder: AppText.StartScreen.namePlaceholder
            )
            
            FormField(
                label: AppText.StartScreen.ageLabel,
                text: $age,
                placeholder: AppText.StartScreen.agePlaceholder,
                keyboardType: .numberPad
            )
            
            FormField(
                label: AppText.StartScreen.heightLabel,
                text: $height,
                placeholder: AppText.StartScreen.heightPlaceholder,
                keyboardType: .numberPad
            )
            
            FormField(
                label: AppText.StartScreen.weightLabel,
                text: $weight,
                placeholder: AppText.StartScreen.weightPlaceholder,
                keyboardType: .numberPad
            )
        }
        .padding(.top, AppSpacing.lg)
    }
}

#Preview {
    UserFormSection(
        name: .constant(""),
        age: .constant(""),
        weight: .constant(""),
        height: .constant("")
    )
    .padding()
}
