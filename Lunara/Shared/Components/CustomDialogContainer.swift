//
//  CustomDialogContainer.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

struct CustomDialogContainer<Content: View>: View {
    let title: String?
    let showsCloseButton: Bool
    let onClose: (() -> Void)?
    @ViewBuilder let content: Content

    init(
        title: String? = nil,
        showsCloseButton: Bool = false,
        onClose: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.showsCloseButton = showsCloseButton
        self.onClose = onClose
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if title != nil || showsCloseButton {
                HStack(spacing: 12) {
                    if let title {
                        Text(title)
                            .font(.manropeSemiBold(size: 18))
                            .foregroundStyle(LunaraColor.cream)
                    }

                    Spacer()

                    if showsCloseButton, let onClose {
                        Button(action: onClose) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(LunaraColor.cream.opacity(0.8))
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(LunaraColor.background.opacity(0.35))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 14)
            }

            content
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(LunaraColor.secondary)
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
        .shadow(color: Color.black.opacity(0.28), radius: 20, x: 0, y: 12)
        .padding(.horizontal, 24)
    }
}

#Preview {
    ZStack {
        LunaraColor.background
            .ignoresSafeArea()

        Color.black.opacity(0.35)
            .ignoresSafeArea()

        CustomDialogContainer(
            title: "Preview Dialog",
            showsCloseButton: true,
            onClose: {}
        ) {
            VStack(spacing: 16) {
                Text("This is a reusable custom dialog container for Lunara.")
                    .font(LunaraFont.body)
                    .foregroundStyle(LunaraColor.cream.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                CustomButton(
                    title: "Done",
                    style: .primary,
                    height: 48
                ) {}
            }
        }
    }
}
