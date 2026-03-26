//
//  LunaraStyling.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 24/03/2026.
//

import SwiftUI

enum LunaraColor {
    
    // Main colors
    static let background: Color = Color(hex: "#161C40")
    static let cream: Color = Color(hex: "#F2F0CE")
    static let pink: Color = Color(hex: "#F294A5")
    static let secondary: Color = Color(hex: "#48468C")
    static let tertiary: Color = Color(hex: "#735A8C")

    // Toolbar
    static let tabBar: Color = Color(hex: "#101634")
    
    // Borders
    static let border: Color = cream.opacity(0.2)
    static let focusedBorder: Color = LunaraColor.cream.opacity(0.8)
}

enum LunaraPadding {
    
    static let screen: CGFloat = 16
    static let compact: CGFloat = 12
}

enum LunaraRadius {
    
    static let bigger: CGFloat = 20
    static let regular: CGFloat = 15
    static let small: CGFloat = 10
}

enum LunaraFont {
    
    // bold
    static let bold = Font.manropeBold(size: 16)
    static let boldSmall = Font.manropeBold(size: 14)
    static let boldExtraSmall = Font.manropeBold(size: 12)
    
    // semiBold
    static let semiBold = Font.manropeSemiBold(size: 16)
    static let semiBoldSmall = Font.manropeSemiBold(size: 14)
    static let semiBoldExtraSmall = Font.manropeSemiBold(size: 12)
    
    // body
    static let body = Font.manropeRegular(size: 16)
    static let bodySmall = Font.manropeRegular(size: 14)
    static let bodyExtraSmall = Font.manropeRegular(size: 12)
    
    // light
    static let light = Font.manropeLight(size: 16)
    static let lightSmall = Font.manropeLight(size: 14)
    static let lightExtraSmall = Font.manropeLight(size: 12)
}

enum LunaraAnimation {
    
    static let quickEase = Animation.easeInOut(duration: 0.2)
    static let standardSpring = Animation.spring(response: 0.28, dampingFraction: 0.75)
    static let softSpring = Animation.spring(response: 0.3, dampingFraction: 0.82)
}

enum LunaraShadow {
    
    static let color = Color.black.opacity(0.28)
    static let radius: CGFloat = 20
    static let y: CGFloat = 12
}
