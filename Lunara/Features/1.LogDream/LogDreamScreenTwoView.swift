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
                    headerSection
                    
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
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Dream Details")
                    .font(.manropeBold(size: 18))
                    .foregroundStyle(LunaraColor.cream)
            }
        }
        .overlay {
            if let errorState = viewModel.errorState {
                ZStack {
                    Color.black.opacity(0.37)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(LunaraAnimation.quickEase) {
                                viewModel.clearError()
                            }
                        }

                    ConfirmationDialogView(
                        title: errorState.title,
                        message: errorState.message,
                        primaryButtonTitle: "Okay",
                        showsCancelButton: false,
                        primaryAction: {
                            withAnimation(LunaraAnimation.quickEase) {
                                viewModel.clearError()
                            }
                        },
                        dismissAction: {
                            withAnimation(LunaraAnimation.quickEase) {
                                viewModel.clearError()
                            }
                        }
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
                }
            }
        }
        .animation(LunaraAnimation.quickEase, value: viewModel.errorState != nil)
    }
}

private extension LogDreamScreenTwoView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Add a few final details to complete your entry.")
                .font(LunaraFont.bodySmall)
                .foregroundStyle(LunaraColor.cream)
        }
        .padding(.horizontal, Constants.screenPadding)
        .padding(.bottom, 2)
    }
    
    var saveSection: some View {
        CustomButton(
            title: viewModel.isSaving ? "Saving..." : "Save Dream",
            style: .primary,
            height: 56,
            isDisabled: viewModel.isSaveDisabled || viewModel.isSaving
        ) {
            saveDream()
        }
        .padding(.horizontal, Constants.screenPadding)
        .padding(.top, 4)
    }

    func saveDream() {
        guard !viewModel.isSaving else { return }

        do {
            let savedEntry = try viewModel.saveDream(using: modelContext)
            dismiss()
            router.handleDreamSaved(savedEntry.id)
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
