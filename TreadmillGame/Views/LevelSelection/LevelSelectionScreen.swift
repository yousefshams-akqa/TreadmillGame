import SwiftUI

struct LevelSelectionScreen: View {
    @StateObject private var viewModel: LevelSelectionViewModel
    
    let userData: UserModel
    
    init(userHeight: String, userData: UserModel) {
        self.userData = userData
        _viewModel = StateObject(wrappedValue: LevelSelectionViewModel(userHeight: userHeight))
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            LevelSelectionHeader()
            
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: AppSpacing.lg) {
                        ForEach(viewModel.levels) { levelPreview in
                            LevelCard(preview: levelPreview) {
                                Task {
                                    await viewModel.selectLevel(id: levelPreview.id)
                                }
                            }
                        }
                    }
                    .padding(AppSpacing.screenPadding)
                }
            }
        }
        .navigationBarBackButtonHidden(false)
        .navigationDestination(isPresented: $viewModel.showGame) {
            if let controller = viewModel.gameController {
                GameScreen(userData: userData)
                    .environmentObject(controller)
            }
        }
        .task {
            await viewModel.loadLevels()
        }
    }
}

#Preview {
    NavigationStack {
        LevelSelectionScreen(
            userHeight: "175",
            userData: UserModel(name: "Test", age: "25", weight: "70", height: "175")
        )
    }
}

