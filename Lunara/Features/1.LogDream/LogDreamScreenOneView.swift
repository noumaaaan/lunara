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
    
    @AppStorage("displayName") private var displayName: String = ""

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
                .contentShape(Rectangle())
                .onTapGesture {
                    dismissKeyboard()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
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
                    dismissKeyboard()
                }
                .font(LunaraFont.body)
            }
        }
        .navigationDestination(isPresented: $shouldNavigateToDetails) {
            LogDreamScreenTwoView(viewModel: viewModel)
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

private extension LogDreamScreenOneView {
    var titleSection: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(welcomeTitle)
                .font(LunaraFont.lightSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.9))
                .padding(.bottom, 10)

            CustomTextField(
                text: $viewModel.title,
                placeholder: "Optional title",
                height: Constants.titleFieldHeight,
                isFocused: $isTitleFocused
            )
            .submitLabel(.next)
            .onSubmit {
                isTitleFocused = false
                isDreamContentFocused = true
            }
        }
    }

    func contentSection(editorMinHeight: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("So, what happened?")
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
        VStack(spacing: 12) {
            CustomButton(
                title: "Next",
                style: .primary,
                height: 56,
                isDisabled: viewModel.isSaveDisabled || viewModel.isSaving
            ) {
                dismissKeyboard()
                shouldNavigateToDetails = true
            }

            CustomButton(
                title: viewModel.isSaving ? "Saving..." : "Save for Now",
                style: .secondary,
                height: 50,
                isDisabled: viewModel.isSaveDisabled || viewModel.isSaving
            ) {
                saveDream()
            }
        }
    }
    
    var welcomeTitle: String {
        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            return "Welcome, log your dream"
        } else {
            return "Welcome \(trimmedName), log your dream"
        }
    }

    func dismissKeyboard() {
        isDreamContentFocused = false
        isTitleFocused = false
    }

    func saveDream() {
        guard !viewModel.isSaving else { return }

        dismissKeyboard()

        do {
            let savedEntry = try viewModel.saveDream(using: modelContext)
            router.handleDreamSaved(savedEntry.id)
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
