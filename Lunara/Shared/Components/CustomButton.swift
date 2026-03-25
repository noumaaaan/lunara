//
//  CustomButton.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import Foundation
import SwiftUI

enum CustomButtonStyle {
    case primary
    case secondary
}

struct CustomButton: View {
    let title: String
    let style: CustomButtonStyle
    let height: CGFloat
    let isDisabled: Bool
    let action: () -> Void

    init(
        title: String,
        style: CustomButtonStyle = .primary,
        height: CGFloat = 56,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.height = height
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(titleFont)
                .foregroundStyle(titleColor)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(backgroundView)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }

    private var titleFont: Font {
        switch style {
        case .primary:
            return .manropeSemiBold(size: 16)
        case .secondary:
            return .manropeMedium(size: 15)
        }
    }

    private var titleColor: Color {
        switch style {
        case .primary:
            return LunaraColor.background
        case .secondary:
            return LunaraColor.cream.opacity(0.95)
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
                .fill(LunaraColor.cream)

        case .secondary:
            RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
                .fill(LunaraColor.secondary.opacity(0.9))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
                        .stroke(LunaraColor.borderColor, lineWidth: 1)
                }
        }
    }
}
