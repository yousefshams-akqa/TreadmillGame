//
//  UserInfoLogic.swift
//  TreadmillGame
//
//  Created by Yousef Shams on 24/01/2026.
//

import Foundation

class UserInfoLogic : ObservableObject {
    @Published var isLoading = false
    
    func start(name : String, age : String, weight : String, height: String) async throws {
        let task = Task { @MainActor in
            isLoading = true
        }
        await task.value
        let user = UserModel(name: name, age: age, weight: weight, height: height)
        UserDefaults.standard.set(user.toJson(), forKey: "user")
        let json = UserDefaults.standard.object(forKey: "user") as! Dictionary<String, Any>
        try? await Task.sleep(for: .seconds(2))
        print(UserModel.fromJson(data: json))

        Task { @MainActor in
            isLoading = false
        }
    }
    
    

}
