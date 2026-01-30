//
//  StartButton.swift
//  TreadmillGame
//
//  Created by Yousef Shams on 24/01/2026.
//

import SwiftUI

struct StartButton: View {
    var startFunc : () -> Void
    var body: some View {
        Button(action: startFunc) {
            Text("Start")
        }
        
        .buttonStyle(.bordered)
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    StartButton(startFunc: start)
}

func start () {}
