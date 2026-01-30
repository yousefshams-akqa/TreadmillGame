//
//  StartPageTitle.swift
//  TreadmillGame
//
//  Created by Yousef Shams on 25/01/2026.
//

import SwiftUI

struct StartPageTitle: View {
    var body: some View {
        HStack {
            Text("Good to see you!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading, 30)
            Spacer()
        }
    }
}

#Preview {
    StartPageTitle()
}
