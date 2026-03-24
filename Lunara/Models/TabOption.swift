//
//  TabOption.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 24/03/2026.
//

import Foundation
import SwiftUI

enum TabOption: String, Codable, CaseIterable {
    case calendar
    case journal
    case log
    case insights
    case preferences

    var displayName: String {
        switch self {
        case .calendar: "Calendar"
        case .journal: "Journal"
        case .log: "Log"
        case .insights: "Insights"
        case .preferences: "Preferences"
        }
    }
    
    var image: String {
        switch self {
        case .calendar: "calendar"
        case .journal: "journal"
        case .log: "write"
        case .insights: "chart"
        case .preferences: "settings"
        }
    }
    
    var color: Color {
        switch self {
        case .calendar: return .red
        case .journal: return .yellow
        case .log: return .green
        case .insights: return .blue
        case .preferences: return .gray
        }
    }
}
