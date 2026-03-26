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

    private let columns = Array(repeating: GridItem(.flexible()), count: 5)

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(spacing: .zero) {
                Text("How are you feeling now?")
                    .font(LunaraFont.lightSmall)
                    .foregroundStyle(LunaraColor.cream.opacity(0.9))

                Spacer()
                
                Text(selectedMood.displayName)
                    .font(LunaraFont.semiBold)
                    .foregroundStyle(LunaraColor.cream)
            }
            .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: Constants.gridSpacing) {
                ForEach(WakingMood.allCases, id: \.self) { mood in
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                            selectedMood = mood
                        }
                    } label: {
                        Image(mood.image)
                            .foregroundStyle(iconColor(for: mood))
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.itemHeight)
                            .background(background(for: mood))
                            .scaleEffect(mood == selectedMood ? 1.1 : 1)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }

    private func iconColor(for mood: WakingMood) -> Color {
        mood == selectedMood ? LunaraColor.cream : mood.color
    }

    @ViewBuilder
    private func background(for mood: WakingMood) -> some View {
        RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
            .fill(mood == selectedMood ? mood.color : LunaraColor.secondary.opacity(0.35))
            .overlay {
                RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                    .stroke(
                        mood == selectedMood ? LunaraColor.focusedBorder : LunaraColor.border,
                        lineWidth: 1
                    )
            }
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
