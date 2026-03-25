//
//  ConfirmationDialogView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

struct ConfirmationDialogView: View {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let showsCancelButton: Bool
    let primaryAction: () -> Void
    let dismissAction: () -> Void

    var body: some View {
        CustomDialogContainer(title: title) {
            VStack(spacing: 18) {
                Text(message)
                    .font(LunaraFont.body)
                    .foregroundStyle(LunaraColor.cream.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                VStack(spacing: 10) {
                    CustomButton(
                        title: primaryButtonTitle,
                        style: .primary,
                        height: 50
                    ) {
                        primaryAction()
                    }

                    if showsCancelButton {
                        CustomButton(
                            title: "Cancel",
                            style: .secondary,
                            height: 46
                        ) {
                            dismissAction()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        LunaraColor.background
            .ignoresSafeArea()

        Color.black.opacity(0.35)
            .ignoresSafeArea()

        ConfirmationDialogView(
            title: "Delete Dream?",
            message: "Are you sure you want to delete this dream? This action cannot be undone.",
            primaryButtonTitle: "Delete Dream",
            showsCancelButton: true,
            primaryAction: {},
            dismissAction: {}
        )
    }
}
