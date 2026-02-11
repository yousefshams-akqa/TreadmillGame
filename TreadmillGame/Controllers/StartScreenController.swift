//
//  StartScreenController.swift
//  TreadmillGame
//
//  Created by Yousef Shams on 24/01/2026.
//

import Foundation

class StartScreenController: ObservableObject {
    @Published var isLoading = false
    
    func start(name: String, age: String, weight: String, height: String) async throws {
        let task = Task { @MainActor in
            isLoading = true
        }
        await task.value
        
        let user = UserModel(name: name, age: age, weight: weight, height: height)
        user.save()
        
        try? await Task.sleep(for: .seconds(2))

        Task { @MainActor in
            isLoading = false
        }
    }

    func loadUser() -> UserModel? {
        return UserModel.load()
    }
}
