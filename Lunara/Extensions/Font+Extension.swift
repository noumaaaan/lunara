//
//  Font+Lunara.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 24/03/2026.
//

import Foundation
import SwiftUI

extension Font {
    
    // MARK: - Regular
    static func manropeRegular(size: CGFloat) -> Font {
        .custom("Manrope-Regular", size: size)
    }
    
    static func manropeMedium(size: CGFloat) -> Font {
        .custom("Manrope-Medium", size: size)
    }
    
    // MARK: - Light
    static func manropeExtraLight(size: CGFloat) -> Font {
        .custom("Manrope-ExtraLight", size: size)
    }
    
    static func manropeLight(size: CGFloat) -> Font {
        .custom("Manrope-Light", size: size)
    }
    
    // MARK: - Bold
    static func manropeSemiBold(size: CGFloat) -> Font {
        .custom("Manrope-SemiBold", size: size)
    }
    
    static func manropeBold(size: CGFloat) -> Font {
        .custom("Manrope-Bold", size: size)
    }
    
    static func manropeExtraBold(size: CGFloat) -> Font {
        .custom("Manrope-ExtraBold", size: size)
    }
    
    // MARK: - Semantic styles
    static let lunaraLargeTitle = Font.manropeBold(size: 34)
    static let lunaraTitle = Font.manropeBold(size: 28)
    static let lunaraTitle2 = Font.manropeSemiBold(size: 22)
    static let lunaraHeadline = Font.manropeSemiBold(size: 17)
    static let lunaraBody = Font.manropeRegular(size: 16)
    static let lunaraBodyMedium = Font.manropeMedium(size: 16)
    static let lunaraCallout = Font.manropeMedium(size: 15)
    static let lunaraCaption = Font.manropeRegular(size: 13)
    static let lunaraSmall = Font.manropeRegular(size: 12)
    static let lunaraButton = Font.manropeSemiBold(size: 16)
    static let lunaraNavTitle = Font.manropeSemiBold(size: 18)
    static let lunaraTabLabel = Font.manropeMedium(size: 11)
    static let lunaraLogo = Font.manropeBold(size: 30)
}
