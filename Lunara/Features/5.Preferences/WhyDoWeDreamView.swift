//
//  WhyDoWeDreamView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 26/03/2026.
//

import Foundation
import SwiftUI

struct WhyDoWeDreamView: View {
    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    textCard(
                        title: "Why do we dream?",
                        body: "There is no single final answer, but researchers generally think dreams are linked to memory, emotion, and the brain’s processing during sleep."
                    )

                    textCard(
                        title: "Memory and learning",
                        body: "Some theories suggest dreaming helps the brain sort, strengthen, and organise experiences from the day."
                    )

                    textCard(
                        title: "Emotion and reflection",
                        body: "Dreams may also reflect emotions, worries, hopes, or unresolved thoughts. That does not mean every dream has a hidden message, but patterns can still be meaningful."
                    )

                    textCard(
                        title: "Why log them?",
                        body: "Writing dreams down helps you remember them more clearly, notice recurring themes, and build your own sense of what they mean to you."
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
                Text("Why do we dream?")
                    .font(LunaraFont.bold)
                    .foregroundStyle(LunaraColor.cream)
            }
        }
    }

    private func textCard(title: String, body: String) -> some View {
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
        WhyDoWeDreamView()
    }
}
