//
//  CustomTextEditorView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

private enum Constants {
    static let cornerRadius: CGFloat = 20
    static let minHeight: CGFloat = 220

    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 14

    static let borderColor = LunaraColor.borderColor
    static let focusedBorderColor = LunaraColor.cream.opacity(0.8)

    static let textColor = LunaraColor.cream
    static let placeholderColor = LunaraColor.cream.opacity(0.65)
}

struct CustomTextEditorView: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding

    private var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                .fill(LunaraColor.secondary)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                        .stroke(
                            isFocused.wrappedValue
                            ? Constants.focusedBorderColor
                            : Constants.borderColor,
                            lineWidth: 1
                        )
                }

            if isEmpty {
                Text("Write your dream before it fades...")
                    .font(.manropeRegular(size: 16))
                    .foregroundStyle(Constants.placeholderColor)
                    .padding(.horizontal, Constants.horizontalPadding)
                    .padding(.vertical, Constants.verticalPadding)
                    .allowsHitTesting(false)
            }

            TextEditor(text: $text)
                .focused(isFocused)
                .scrollContentBackground(.hidden)
                .foregroundStyle(Constants.textColor)
                .font(.manropeRegular(size: 16))
                .padding(.horizontal, Constants.horizontalPadding - 4)
                .padding(.vertical, Constants.verticalPadding - 4)
        }
        .frame(maxWidth: .infinity, minHeight: Constants.minHeight)
        .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
        .onTapGesture {
            isFocused.wrappedValue = true
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused.wrappedValue)
    }
}

#Preview {
    PreviewContainer()
}

private struct PreviewContainer: View {
    @State private var text: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            CustomTextEditorView(
                text: $text,
                isFocused: $isFocused
            )
            .padding()
        }
    }
}
