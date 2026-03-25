//
//  DreamEntry.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import Foundation
import SwiftData

/// TODO: In the future add tags, moonphase

@Model
final class DreamEntry {
    var id: UUID
    var created: Date
    var modified: Date
    var dreamDate: Date
    var title: String
    var content: String
    var category: DreamCategory
    var intensity: Int
    var wakingMood: WakingMood
    
    init(
        id: UUID = UUID(),
        created: Date = Date(),
        modified: Date = Date(),
        dreamDate: Date = Date(),
        title: String,
        content: String,
        category: DreamCategory,
        intensity: Int,
        wakingMood: WakingMood
    ) {
        self.id = id
        self.created = created
        self.modified = modified
        self.dreamDate = dreamDate
        self.title = title
        self.content = content
        self.category = category
        self.intensity = intensity
        self.wakingMood = wakingMood
    }
}
