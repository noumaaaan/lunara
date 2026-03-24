//
//  AppColors.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 24/03/2026.
//

import Foundation
import SwiftUI

enum AppColors {
    
    // MARK: - Brand Palette
    
    static let oxfordBlue = Color(hex: "#11253C")
    static let paynesGray = Color(hex: "#606479")
    static let powderBlue = Color(hex: "#B2C8EB")
    static let teaRose = Color(hex: "#EEC6C3")
    static let roseQuartz = Color(hex: "#A19299")
    
    // MARK: - Semantic Colors
    
    static let backgroundPrimary = oxfordBlue
    static let backgroundSecondary = Color(hex: "#1D2F47")
    
    static let surfacePrimary = Color(hex: "#1D2F47")
    static let surfaceSecondary = paynesGray.opacity(0.35)
    
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "#C6D0E0")
    static let textMuted = Color(hex: "#7F8A9D")
    
    static let accentPrimary = powderBlue
    static let accentSecondary = teaRose
    static let accentTertiary = roseQuartz
    
    static let tabBarBackground = Color(hex: "#1D2F47")
    static let tabSelected = powderBlue
    static let tabUnselected = Color(hex: "#7F8A9D")
    
    static let borderSubtle = Color.white.opacity(0.08)
    static let overlaySoft = Color.white.opacity(0.10)
    
    static let success = Color(hex: "#7FB6A6")
    static let warning = Color(hex: "#D6A86D")
    static let error = Color(hex: "#C97C8A")
}
