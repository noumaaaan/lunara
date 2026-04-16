//
//  WakingMoodSelectionView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

private enum Constants {
    static let itemHeight: CGFloat = 50
    static let horizontalPadding: CGFloat = 16
    static let gridSpacing: CGFloat = 8
}

struct WakingMoodSelectionView: View {
    @Binding var selectedMood: WakingMood

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: Constants.gridSpacing),
        count: 5
    )

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            headerSection

            LazyVGrid(columns: columns, alignment: .center, spacing: Constants.gridSpacing) {
                ForEach(WakingMood.allCases, id: \.self) { mood in
                    moodButton(for: mood)
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

private extension WakingMoodSelectionView {
    var headerSection: some View {
        HStack(spacing: .zero) {
            Text("How are you feeling now?")
                .font(LunaraFont.lightSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.9))

            Spacer()

            Text(selectedMood.displayName)
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)
                .contentTransition(.opacity)
                .animation(.easeInOut(duration: 0.18), value: selectedMood)
        }
        .padding(.bottom, 10)
    }

    @ViewBuilder
    func moodButton(for mood: WakingMood) -> some View {
        Button {
            guard selectedMood != mood else { return }

            withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                selectedMood = mood
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                    .fill(mood == selectedMood ? mood.color : LunaraColor.secondary.opacity(0.35))
                    .overlay {
                        RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                            .stroke(
                                mood == selectedMood ? LunaraColor.focusedBorder : LunaraColor.border,
                                lineWidth: 1
                            )
                    }

                Image(mood.image)
                    .renderingMode(.template)
                    .foregroundStyle(iconColor(for: mood))
                    .scaleEffect(mood == selectedMood ? 1.08 : 1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.itemHeight)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(mood.displayName)
        .accessibilityAddTraits(mood == selectedMood ? [.isButton, .isSelected] : .isButton)
    }

    func iconColor(for mood: WakingMood) -> Color {
        mood == selectedMood ? LunaraColor.cream : mood.color
    }
}

// Preview wrapper
private struct WakingMoodSelectionViewWrapper: View {
    @State private var selectedMood: WakingMood = .neutral

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            WakingMoodSelectionView(selectedMood: $selectedMood)
        }
    }
}

#Preview {
    WakingMoodSelectionViewWrapper()
}
