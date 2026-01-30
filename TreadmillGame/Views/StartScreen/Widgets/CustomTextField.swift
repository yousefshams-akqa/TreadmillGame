//
//  CustomTextField.swift
//  TreadmillGame
//
//  Created by Yousef Shams on 24/01/2026.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text : String
    var placeholder: String
    var width : CGFloat?
    var type : UIKeyboardType?
    var body: some View {
        TextField(text: $text) {
            Text(placeholder)
        }
        .frame(width: width ?? 200)
        .textFieldStyle(.roundedBorder)
        .keyboardType(type ?? .default)
    }
}

#Preview {
    CustomTextField(text: .constant(""), placeholder: "Email")
}
