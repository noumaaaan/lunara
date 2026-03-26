//
//  JournalRowView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

private enum Constants {
    static let cardPadding: CGFloat = 15
    static let chipSpacing: CGFloat = 8
    static let verticalSpacing: CGFloat = 10
}

struct JournalRowView: View {
    let entry: DreamEntry

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
            HStack {
                Text(entry.dreamDate.formatted(.dateTime.weekday(.wide).day().month(.wide).year()))
                    .font(.manropeLight(size: 11))
                    .textCase(.uppercase)
                    .foregroundStyle(LunaraColor.cream.opacity(0.7))

                Spacer()

                Text(intensityText)
                    .font(.manropeLight(size: 11))
                    .textCase(.uppercase)
                    .foregroundStyle(LunaraColor.cream.opacity(0.7))
            }

            VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
                if !trimmedTitle.isEmpty {
                    Text(trimmedTitle)
                        .font(.manropeSemiBold(size: 16))
                        .foregroundStyle(LunaraColor.cream)
                        .lineLimit(1)
                }

                Text(entry.content)
                    .font(LunaraFont.body)
                    .foregroundStyle(LunaraColor.cream.opacity(0.9))
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)

                HStack(spacing: Constants.chipSpacing) {
                    chip(
                        text: "\(entry.category.displayName) dream",
                        color: entry.category.color
                    )

                    chip(
                        text: "Woke up \(entry.wakingMood.displayName)",
                        color: entry.wakingMood.color
                    )
                }
            }
            .padding(Constants.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                    .fill(LunaraColor.secondary)
                    .overlay {
                        RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                            .stroke(LunaraColor.border, lineWidth: 1)
                    }
            )
        }
    }

    private var trimmedTitle: String {
        entry.title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var intensityText: String {
        DreamIntensity(rawValue: entry.intensity)?.displayName ?? "\(entry.intensity)"
    }

    private func chip(text: String, color: Color) -> some View {
        Text(text)
            .font(.manropeLight(size: 11))
            .textCase(.uppercase)
            .foregroundStyle(LunaraColor.cream)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(color.opacity(0.75))
            )
    }
}

#Preview {
    ZStack {
        LunaraColor.background
            .ignoresSafeArea()

        JournalRowView(
            entry: DreamEntry(
                dreamDate: Date(),
                title: "Flying over the city",
                content: "I was walking through a glowing city and then suddenly I was back in school sitting an exam I had not revised for. It felt vivid and strange.",
                category: .weird,
                intensity: 3,
                wakingMood: .anxious
            )
        )
        .padding()
    }
}
