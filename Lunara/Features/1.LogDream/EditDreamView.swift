//
//  EditDreamView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 26/03/2026.
//

import Foundation
import SwiftUI
import SwiftData

private enum Constants {
    static let screenPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 20
    static let titleFieldHeight: CGFloat = 50
    static let bottomContentPadding: CGFloat = 120
}

struct EditDreamView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let entry: DreamEntry

    @StateObject private var viewModel: LogDreamViewModel
    @FocusState private var isDreamContentFocused: Bool
    @FocusState private var isTitleFocused: Bool

    init(entry: DreamEntry) {
        self.entry = entry
        _viewModel = StateObject(wrappedValue: LogDreamViewModel(entry: entry))
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LunaraColor.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                        titleSection
                        contentSection(editorMinHeight: proxy.size.height * 0.32)
                        DateSelectionView(selectedDate: $viewModel.dreamDate)

                        CategorySelectionView(
                            selectedCategory: $viewModel.selectedCategory
                        )

                        DreamIntensityView(
                            selectedIntensity: Binding(
                                get: { viewModel.currentIntensity },
                                set: { viewModel.selectedIntensity = $0.rawValue }
                            )
                        )

                        WakingMoodSelectionView(
                            selectedMood: $viewModel.selectedMood
                        )

                        actionSection
                    }
                    .padding(Constants.screenPadding)
                    .padding(.bottom, Constants.bottomContentPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(minHeight: proxy.size.height, alignment: .top)
                }
                .scrollIndicators(.hidden)
                .simultaneousGesture(
                    TapGesture().onEnded {
                        isDreamContentFocused = false
                        isTitleFocused = false
                    }
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit Dream")
                    .font(.manropeBold(size: 18))
                    .foregroundStyle(LunaraColor.cream)
            }

            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    isDreamContentFocused = false
                    isTitleFocused = false
                }
                .font(LunaraFont.body)
            }
        }
    }
}

private extension EditDreamView {
    var titleSection: some View {
        CustomTextField(
            text: $viewModel.title,
            placeholder: "Optional title",
            height: Constants.titleFieldHeight,
            isFocused: $isTitleFocused
        )
    }

    func contentSection(editorMinHeight: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("What happened?")
                .font(LunaraFont.lightSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.9))
                .padding(.bottom, 10)

            CustomTextEditorView(
                text: $viewModel.content,
                isFocused: $isDreamContentFocused
            )
            .frame(minHeight: editorMinHeight)
        }
    }

    var actionSection: some View {
        CustomButton(
            title: "Save Changes",
            style: .primary,
            height: 56,
            isDisabled: viewModel.isSaveDisabled
        ) {
            saveChanges()
        }
        .padding(.top, 4)
    }

    func saveChanges() {
        do {
            try viewModel.updateDream(entry, using: modelContext)
            isDreamContentFocused = false
            isTitleFocused = false
            dismiss()
        } catch {
            print("Failed to update dream: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        EditDreamView(
            entry: DreamEntry(
                dreamDate: Date(),
                title: "Flying over the city",
                content: "I was flying over a glowing city and then suddenly I was back in school sitting an exam I had not revised for.",
                category: .weird,
                intensity: 4,
                wakingMood: .anxious
            )
        )
    }
}
