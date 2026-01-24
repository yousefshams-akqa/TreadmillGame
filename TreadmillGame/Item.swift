//
//  Item.swift
//  TreadmillGame
//
//  Created by Yousef Shams on 24/01/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
