import SwiftUI

/// Displays the level name at the top of the game screen
struct LevelHeaderView: View {
    let levelName: String
    
    var body: some View {
        Text(levelName)
            .font(AppFonts.title2())
            .fontWeight(.semibold)
    }
}

#Preview {
    LevelHeaderView(levelName: "Chase Level")
}
