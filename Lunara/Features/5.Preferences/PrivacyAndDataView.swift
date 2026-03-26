//
//  PrivacyAndDataView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 26/03/2026.
//

import Foundation
import SwiftUI

struct PrivacyAndDataView: View {
    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    privacyCard(
                        title: "Your dreams",
                        body: "Your journal entries are personal. Lunara is designed to treat them that way."
                    )

                    privacyCard(
                        title: "Stored on your device",
                        body: "In this version of Lunara, your dream data is stored locally on your device. There is no account system or cloud sync yet."
                    )

                    privacyCard(
                        title: "Suggestions and external links",
                        body: "If you use Suggestions or Buy Me a Coffee, those actions open external apps or websites."
                    )

                    privacyCard(
                        title: "Future changes",
                        body: "If Lunara adds sync, export, or backup features later, privacy and data handling should be clearly explained here."
                    )
                }
                .padding(.horizontal, LunaraPadding.screen)
                .padding(.top, LunaraPadding.screen)
                .padding(.bottom, 40)
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

    private func privacyCard(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)

            Text(body)
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
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
