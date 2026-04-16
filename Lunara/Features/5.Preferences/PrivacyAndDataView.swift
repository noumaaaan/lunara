//
//  PrivacyAndDataView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 26/03/2026.
//

import Foundation
import SwiftUI

private enum Constants {
    static let sectionSpacing: CGFloat = 18
    static let cardPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 100
}

struct PrivacyAndDataView: View {
    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                    headerSection

                    privacyCard(
                        title: "Your dreams",
                        body: "Your journal entries are personal. Lunara is designed to treat them that way."
                    )

                    privacyCard(
                        title: "Stored on your device",
                        body: "With Lunara, your dream data is stored locally on your device. There is no account system or cloud sync. No one other than you can see it."
                    )

                    privacyCard(
                        title: "External actions",
                        body: "If you use Suggestions, Lunara may open your mail app so you can send feedback. Any external app or website then follows its own privacy practices."
                    )

                    privacyCard(
                        title: "No account required",
                        body: "You can use Lunara without creating an account. That means there is currently no personal profile stored on external servers through the app."
                    )

                    privacyCard(
                        title: "Future changes",
                        body: "If Lunara adds sync, export, backup, or account features later, privacy and data handling will be clearly explained here."
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, LunaraPadding.screen)
                .padding(.top, LunaraPadding.screen)
                .padding(.bottom, Constants.bottomPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Privacy / Your data")
                    .font(LunaraFont.bold)
                    .foregroundStyle(LunaraColor.cream)
            }
        }
    }
}

private extension PrivacyAndDataView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(LunaraColor.pink)

                Text("PRIVACY")
                    .font(LunaraFont.lightExtraSmall)
                    .foregroundStyle(LunaraColor.cream.opacity(0.72))
                    .textCase(.uppercase)
            }

            Text("Your dreams should feel private.")
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)

            Text("Lunara is built to keep things simple and personal. In this version, your entries stay on your device, with no account or cloud sync required.")
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                .fill(LunaraColor.tertiary.opacity(0.5))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
    }

    func privacyCard(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)

            Text(body)
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                .fill(LunaraColor.secondary.opacity(0.72))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
    }
}

#Preview {
    NavigationStack {
        PrivacyAndDataView()
    }
}
