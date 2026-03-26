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

    private let columns = Array(repeating: GridItem(.flexible(), spacing: Constants.gridSpacing), count: 5)

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(spacing: .zero) {
                Text("How intense was it?")
                    .font(LunaraFont.lightSmall)
                    .foregroundStyle(LunaraColor.cream.opacity(0.9))

                Spacer()

                Text(selectedIntensity.displayName)
                    .font(LunaraFont.semiBold)
                    .foregroundStyle(LunaraColor.cream)
            }
            .padding(.bottom, 10)

            LazyVGrid(columns: columns, alignment: .center, spacing: Constants.gridSpacing) {
                ForEach(DreamIntensity.allCases, id: \.self) { intensity in
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                            selectedIntensity = intensity
                        }
                    } label: {
                        Text(String(intensity.rawValue))
                            .font(LunaraFont.semiBold)
                            .foregroundStyle(foregroundColor(for: intensity))
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.itemHeight)
                            .background(background(for: intensity))
                            .scaleEffect(intensity == selectedIntensity ? 1.1 : 1)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }

    private func foregroundColor(for intensity: DreamIntensity) -> Color {
        intensity == selectedIntensity ? LunaraColor.cream : intensity.color
    }

    @ViewBuilder
    private func background(for intensity: DreamIntensity) -> some View {
        RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
            .fill(intensity == selectedIntensity ? intensity.color : LunaraColor.secondary.opacity(0.35))
            .overlay {
                RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                    .stroke(
                        intensity == selectedIntensity ? LunaraColor.focusedBorder : LunaraColor.border,
                        lineWidth: 1
                    )
            }
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

