//
//  TreadmillGameApp.swift
//  TreadmillGame
//
//  Created by Yousef Shams on 24/01/2026.
//

import SwiftUI
import SwiftData

@main
struct TreadmillGameApp: App {
    @StateObject var userInfoLogic = UserInfoLogic()
    var body: some Scene {
        WindowGroup {
            StartScreen()
                .environmentObject(userInfoLogic)
        }
    }
}
