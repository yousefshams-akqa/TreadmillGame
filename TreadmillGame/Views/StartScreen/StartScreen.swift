import SwiftUI
import CoreMotion

struct StartScreen: View {
    @EnvironmentObject private var userInfoLogic: StartScreenController
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var showLevelSelection: Bool = false
    @State private var showSettings: Bool = false

    private var isFormValid: Bool {
        !name.isEmpty && !height.isEmpty && Double(height) != nil && Double(weight) != nil
    }

    var body: some View {
        if userInfoLogic.isLoading {
            ProgressView()
        } else {
            NavigationStack {
                ScrollView {
                    VStack(spacing: AppSpacing.xxl) {
                        Spacer().frame(height: AppSpacing.md)
                        
                        StartScreenHeader()
                        
                        UserFormSection(
                            name: $name,
                            age: $age,
                            weight: $weight,
                            height: $height
                        ).task {
                            guard let user = userInfoLogic.loadUser() else {
                                return
                            }
                            
                            self.name = user.name
                            self.age = user.age
                            self.weight = user.weight
                            self.height = user.height
                        }
                        
                        ContinueButton(isEnabled: isFormValid) {
                            Task {
                                try? await userInfoLogic.start(name: name, age: age, weight: weight, height: height)
                                showLevelSelection = true
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)
                }
                .navigationDestination(isPresented: $showLevelSelection) {
                    LevelSelectionScreen(
                        userHeight: height,
                        userData: UserModel(name: name, age: age, weight: weight, height: height)
                    )
                }
                .sheet(isPresented: $showSettings) {
                    SettingsSheet()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StartScreen().environmentObject(StartScreenController())
}
