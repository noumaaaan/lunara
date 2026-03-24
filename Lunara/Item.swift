//
//  Item.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 24/03/2026.
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
