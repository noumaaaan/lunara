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
    case erotic
    case weird
    case mystical
    case nostalgic
    case other
    
    var displayName: String {
        switch self {
        case .normal: return "Standard"
        case .scary: return "Scary"
        case .erotic: return "Erotic"
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
        case .erotic: return "love"
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
        case .scary: return .init(hex: "#00705E")
        case .anxious: return .init(hex: "#6D60A1")
        case .romantic: return .init(hex: "#f757a7")
        case .lucid: return .init(hex: "#9933ff")
        case .erotic: return .init(hex: "920637")
        case .mystical: return .init(hex: "7f00ff")
        case .nostalgic: return .init(hex: "#3c9296")
        case .weird: return .init(hex: "#3b7007")
        case .other: return .init(hex: "#6B6A6A")
        }
    }
}
