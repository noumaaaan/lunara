//
//  WakingMood.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import Foundation
import SwiftUI

enum WakingMood: String, Codable, CaseIterable {
    case anxious
    case sad
    case neutral
    case calm
    case happy

    var displayName: String {
        switch self {
        case .happy: "Happy"
        case .calm: "Calm"
        case .neutral: "Neutral"
        case .sad: "Sad"
        case .anxious: "Anxious"
        }
    }

    var image: String {
        switch self {
        case .happy: "happyMood"
        case .calm: "calmMood"
        case .neutral: "neutralMood"
        case .sad: "sadMood"
        case .anxious: "anxiousMood"
        }
    }

    var color: Color {
        switch self {
        case .happy: return .init(hex: "#e3a81e")
        case .calm: return .init(hex: "#6c8c38")
        case .neutral: return .init(hex: "#a39184")
        case .sad: return .init(hex: "#2a3b90")
        case .anxious: return .init(hex: "#b32d7f")
        }
    }
}
