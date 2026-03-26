//
//  AboutLunaraView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 26/03/2026.
//

import Foundation
import SwiftUI

struct AboutLunaraView: View {
    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    aboutCard(
                        title: "What is Lunara?",
                        body: "Lunara is a calm place to capture your dreams, revisit them later, and notice patterns over time."
                    )

                    aboutCard(
                        title: "Why it exists",
                        body: "Dreams can fade quickly. Lunara is designed to help you record them fast, explore them later, and build a gentle habit of reflection."
                    )

                    aboutCard(
                        title: "How to use it",
                        body: "Log a dream as soon as you wake up, add a few details, and let your journal, calendar, and insights gradually build a picture over time."
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
                Text("About Lunara")
                    .font(LunaraFont.bold)
                    .foregroundStyle(LunaraColor.cream)
            }
        }
    }

    private func aboutCard(title: String, body: String) -> some View {
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
        AboutLunaraView()
    }
}
