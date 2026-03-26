//
//  CustomTextField.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String

    let placeholder: String
    let height: CGFloat

    var isFocused: FocusState<Bool>.Binding?

    init(
        text: Binding<String>,
        placeholder: String,
        height: CGFloat = 50,
        isFocused: FocusState<Bool>.Binding? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.height = height
        self.isFocused = isFocused
    }

    var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.65))
        )
        .applyFocus(isFocused)
        .font(LunaraFont.body)
        .foregroundStyle(LunaraColor.cream)
        .tint(LunaraColor.cream)
        .padding(.horizontal, 16)
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                .fill(LunaraColor.secondary)
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                        .stroke(
                            isFocused?.wrappedValue == true
                            ? LunaraColor.cream.opacity(0.8)
                            : LunaraColor.border,
                            lineWidth: 1
                        )
                }
        )
    }
}

private extension View {
    @ViewBuilder
    func applyFocus(_ focus: FocusState<Bool>.Binding?) -> some View {
        if let focus {
            self.focused(focus)
        } else {
            self
        }
    }
}
