//
//  DreamIntensityView.swift
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

struct DreamIntensityView: View {
    @Binding var selectedIntensity: DreamIntensity

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: Constants.gridSpacing),
        count: 5
    )

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            headerSection

            LazyVGrid(columns: columns, alignment: .center, spacing: Constants.gridSpacing) {
                ForEach(DreamIntensity.allCases, id: \.self) { intensity in
                    intensityButton(for: intensity)
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

private extension DreamIntensityView {
    var headerSection: some View {
        HStack(spacing: .zero) {
            Text("How intense was it?")
                .font(LunaraFont.lightSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.9))

            Spacer()

            Text(selectedIntensity.displayName)
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)
                .contentTransition(.opacity)
                .animation(.easeInOut(duration: 0.18), value: selectedIntensity)
        }
        .padding(.bottom, 10)
    }

    @ViewBuilder
    func intensityButton(for intensity: DreamIntensity) -> some View {
        Button {
            guard selectedIntensity != intensity else { return }

            withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                selectedIntensity = intensity
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                    .fill(intensity == selectedIntensity ? intensity.color : LunaraColor.secondary.opacity(0.35))
                    .overlay {
                        RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                            .stroke(
                                intensity == selectedIntensity ? LunaraColor.focusedBorder : LunaraColor.border,
                                lineWidth: 1
                            )
                    }

                Text(String(intensity.rawValue))
                    .font(LunaraFont.semiBold)
                    .foregroundStyle(foregroundColor(for: intensity))
                    .scaleEffect(intensity == selectedIntensity ? 1.08 : 1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.itemHeight)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(intensity.displayName)
        .accessibilityValue("\(intensity.rawValue)")
        .accessibilityAddTraits(intensity == selectedIntensity ? [.isButton, .isSelected] : .isButton)
    }

    func foregroundColor(for intensity: DreamIntensity) -> Color {
        intensity == selectedIntensity ? LunaraColor.cream : intensity.color
    }
}

// Preview wrapper
private struct DreamIntensityViewWrapper: View {
    @State private var selectedIntensity: DreamIntensity = .notSoIntense

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            DreamIntensityView(selectedIntensity: $selectedIntensity)
        }
    }
}

#Preview {
    DreamIntensityViewWrapper()
}
