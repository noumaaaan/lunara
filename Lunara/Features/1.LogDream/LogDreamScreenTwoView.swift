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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: AppRouter

    @ObservedObject var viewModel: LogDreamViewModel

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                    DateSelectionView(selectedDate: $viewModel.dreamDate)

                    CategorySelectionView(selectedCategory: $viewModel.selectedCategory)

                    DreamIntensityView(
                        selectedIntensity: Binding(
                            get: { viewModel.currentIntensity },
                            set: { viewModel.selectedIntensity = $0.rawValue }
                        )
                    )

                    WakingMoodSelectionView(selectedMood: $viewModel.selectedMood)

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
            let savedEntry = try viewModel.saveDream(using: modelContext)

            router.savedDreamToastMessage = "Dream saved"
            router.pendingJournalEntryID = savedEntry.id

            dismiss()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                router.savedDreamToastMessage = nil
                router.selectedTab = .journal
            }
        } catch {
            print("Failed to save dream: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        LogDreamScreenTwoView(viewModel: LogDreamViewModel())
            .environmentObject(AppRouter())
    }
}
