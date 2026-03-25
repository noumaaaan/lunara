//
//  LogDreamScreenOneView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI
import SwiftData

private enum Constants {
    static let screenPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 20
    static let titleFieldHeight: CGFloat = 50
    static let bottomContentPadding: CGFloat = 100
}

struct LogDreamScreenOneView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var router: AppRouter

    @StateObject private var viewModel = LogDreamViewModel()
    @FocusState private var isDreamContentFocused: Bool
    @FocusState private var isTitleFocused: Bool
    @State private var shouldNavigateToDetails = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LunaraColor.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                        titleSection
                        contentSection(editorMinHeight: proxy.size.height * 0.42)
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
        .toolbarBackground(LunaraColor.tabBarColor, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Log Dream")
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
        .navigationDestination(isPresented: $shouldNavigateToDetails) {
            LogDreamScreenTwoView(viewModel: viewModel)
        }
    }
}

private extension LogDreamScreenOneView {
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
            Text("So, what happened?")
                .font(LunaraFont.lightBodySmall)
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
        VStack(spacing: 12) {
            CustomButton(
                title: "Next",
                style: .primary,
                height: 56,
                isDisabled: viewModel.isSaveDisabled
            ) {
                shouldNavigateToDetails = true
            }

            CustomButton(
                title: "Save for Now",
                style: .secondary,
                height: 50,
                isDisabled: viewModel.isSaveDisabled
            ) {
                saveDream()
            }
        }
    }

    func saveDream() {
        do {
            let savedEntry = try viewModel.saveDream(using: modelContext)

            isDreamContentFocused = false
            isTitleFocused = false

            router.savedDreamToastMessage = "Dream saved"
            router.pendingJournalEntryID = savedEntry.id

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
        LogDreamScreenOneView()
            .environmentObject(AppRouter())
    }
}
