//
//  JournalSortOption.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI
import Foundation

enum JournalSortOption: CaseIterable, Hashable {
    case newestFirst
    case oldestFirst

    var displayName: String {
        switch self {
        case .newestFirst:
            return "Newest First"
        case .oldestFirst:
            return "Oldest First"
        }
    }
}
