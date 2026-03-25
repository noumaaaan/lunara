//
//  LogDreamScreenTwoView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI
import SwiftData

private enum Constants {
    static let screenPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 20
    static let bottomContentPadding: CGFloat = 100
}

struct LogDreamScreenTwoView: View {
    @Environment(\.modelContext) private var modelContext

    @ObservedObject var viewModel: LogDreamViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                    DateSelectionView(selectedDate: $viewModel.dreamDate)

                    CategorySelectionView(
                        selectedCategory: Binding(
                            get: { viewModel.selectedCategory },
                            set: { viewModel.selectedCategory = $0 }
                        )
                    )

                    DreamIntensityView(
                        selectedIntensity: Binding(
                            get: { viewModel.currentIntensity },
                            set: { viewModel.selectedIntensity = $0.rawValue }
                        )
                    )

                    WakingMoodSelectionView(
                        selectedMood: Binding(
                            get: { viewModel.selectedMood },
                            set: { viewModel.selectedMood = $0 }
                        )
                    )

                    saveSection
                }
                .padding(.top, Constants.screenPadding)
                .padding(.bottom, Constants.bottomContentPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBarColor, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Dream Details")
                    .font(.manropeBold(size: 18))
                    .foregroundStyle(LunaraColor.cream)
            }
        }
    }
}

private extension LogDreamScreenTwoView {
    var saveSection: some View {
        CustomButton(
            title: "Save Dream",
            style: .primary,
            height: 56,
            isDisabled: viewModel.isSaveDisabled
        ) {
            saveDream()
        }
        .padding(.horizontal, Constants.screenPadding)
        .padding(.top, 4)
    }

    func saveDream() {
        do {
            try viewModel.saveDream(using: modelContext)
            dismiss()
        } catch {
            print("Failed to save dream: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        LogDreamScreenTwoView(viewModel: LogDreamViewModel())
    }
}
