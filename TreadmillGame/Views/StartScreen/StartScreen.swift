//
//  ContentView.swift
//  TreadmillGame
//
//  Created by Yousef Shams on 24/01/2026.
//

import SwiftUI
import SwiftData

struct StartScreen: View {
    @EnvironmentObject private var userInfoLogic : UserInfoLogic
    @State private var name : String = ""
    @State private var age : String = ""
    @State private var weight : String = ""
    @State private var height : String = ""
    @State private var showGame : Bool = false

    var body: some View {
        if userInfoLogic.isLoading {
            ProgressView()
        }
        else {
            NavigationStack{
                VStack(alignment: .center) {
                    Spacer().frame(height: 40)
                    // Page Title
                    StartPageTitle()
                    Spacer()
                    // Name input
                    CustomTextField(text: $name, placeholder: "Name")
                    // Age input
                    CustomTextField(text: $age, placeholder: "Age", type: .numberPad)
                    // Height input
                    CustomTextField(text: $height, placeholder: "Height (cm)", type: .numberPad)
                    // Weight input
                    CustomTextField(text: $weight, placeholder: "Weight (kg)", type: .numberPad)
                    Spacer().frame(height: 40)
                    StartButton {
                        Task {
                            try? await userInfoLogic.start(name: name, age: age, weight: weight, height: height)
                            showGame = true
                        }
                    }
                    .frame(maxHeight: 100)
                    Spacer()
                    Spacer()
                }.navigationDestination(isPresented: $showGame) {
                    GameScreen(userData: UserModel(name: name, age: age, weight: weight, height: height)).environmentObject(GameController(stepsRepo: StepsRepository.instance, hapticService: HapticsService()))
                }
            }
        }
    }
    
    
}

#Preview {
    StartScreen().environmentObject(UserInfoLogic())
}
