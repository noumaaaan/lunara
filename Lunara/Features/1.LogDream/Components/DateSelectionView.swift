//
//  DateSelectionView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

private enum Constants {
    static let horizontalPadding: CGFloat = 16
}

struct DateSelectionView: View {
    @Binding var selectedDate: Date

    var body: some View {
        HStack(spacing: .zero) {
            Text("Dream Date")
                .font(LunaraFont.lightSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.9))

            Spacer()

            DatePicker(
                "",
                selection: $selectedDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .tint(LunaraColor.cream)
            .colorScheme(.dark)
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

// Preview wrapper
private struct DateSelectionViewWrapper: View {
    @State private var selectedDate = Date()

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            DateSelectionView(selectedDate: $selectedDate)
        }
    }
}

#Preview {
    DateSelectionViewWrapper()
}
