//
//  DreamIntensity.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import Foundation
import SwiftUI

enum DreamIntensity: Int, CaseIterable, Codable {
    case notSoIntense = 1
    case slightlyIntense = 2
    case moderatelyIntense = 3
    case veryIntense = 4
    case superIntense = 5
    
    var displayName: String {
        switch self {
        case .notSoIntense: return "Not super intense"
        case .slightlyIntense: return "Mildy intense"
        case .moderatelyIntense: return "Okay, quite intense"
        case .veryIntense: return "Very intense"
        case .superIntense: return "Wait, I was dreaming?!"
        }
    }
    
    var color: Color {
        switch self {
        case .notSoIntense: return .init(hex: "#ff8d00")
        case .slightlyIntense: return .init(hex: "#f27038")
        case .moderatelyIntense: return .init(hex: "#ec5300")
        case .veryIntense: return .init(hex: "#db1414")
        case .superIntense: return .init(hex: "#a70000")
        }
    }
}
