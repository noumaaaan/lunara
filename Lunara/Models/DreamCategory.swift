//
//  DreamCategory.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import Foundation
import SwiftUI

enum DreamCategory: String, Codable, CaseIterable {
    
    case normal
    case happy
    case sad
    case scary
    case anxious
    case romantic
    case lucid
    case sexual
    case weird
    case mystical
    case nostalgic
    case other
    
    var displayName: String {
        switch self {
        case .normal: return "Standard"
        case .scary: return "Scary"
        case .sexual: return "Sexual"
        case .weird: return "Weird"
        case .sad: return "Sad"
        case .happy: return "Happy"
        case .romantic: return "Romantic"
        case .anxious: return "Anxious"
        case .other: return "Other"
        case .lucid: return "Lucid"
        case .mystical: return "Mystical"
        case .nostalgic: return "Nostalgic"
        }
    }
    
    var image: String {
        switch self {
        case .normal: return "normal"
        case .happy: return "happy"
        case .sad: return "sad"
        case .scary: return "scary"
        case .anxious: return "anxious"
        case .romantic: return "romantic"
        case .lucid: return "lucid"
        case .sexual: return "love"
        case .mystical: return "mystical"
        case .nostalgic: return "nostalgic"
        case .weird: return "weird"
        case .other: return "other"
        }
    }
    
    var color: Color {
        switch self {
        case .normal: return .init(hex: "#a39184")
        case .happy: return .init(hex: "#e3a81e")
        case .sad: return .init(hex: "#205578")
        case .scary: return .init(hex: "#013b34")
        case .anxious: return .init(hex: "#443575")
        case .romantic: return .init(hex: "#f757a7")
        case .lucid: return .init(hex: "#9933ff")
        case .sexual: return .init(hex: "920637")
        case .mystical: return .init(hex: "7f00ff")
        case .nostalgic: return .init(hex: "#3c9296")
        case .weird: return .init(hex: "#3b7007")
        case .other: return .init(hex: "393939")
        }
    }
}
