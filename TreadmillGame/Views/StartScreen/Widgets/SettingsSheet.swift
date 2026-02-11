import SwiftUI

struct SettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settings = UserSettings.load()
    
    var body: some View {
        NavigationView {
            Form {
                Section(AppText.Settings.feedbackSection) {
                    Toggle(AppText.Settings.hapticFeedback, isOn: $settings.hapticsEnabled)
                    Toggle(AppText.Settings.voiceFeedback, isOn: $settings.ttsEnabled)
                }
                
                if settings.ttsEnabled {
                    Section(AppText.Settings.voiceSection) {
                        VStack(alignment: .leading) {
                            Text("\(AppText.Settings.volume): \(Int(settings.ttsVolume * 100))%")
                            Slider(value: $settings.ttsVolume, in: 0...1)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(AppText.Settings.speechRate): \(Int(settings.ttsSpeechRate * 100))%")
                            Slider(value: $settings.ttsSpeechRate, in: 0.1...1)
                        }
                    }
                }
            }
            .navigationTitle(AppText.Settings.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(AppText.Settings.done) {
                        settings.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsSheet()
}
