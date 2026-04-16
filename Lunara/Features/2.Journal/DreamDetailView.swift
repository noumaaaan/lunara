//
//  DreamDetailView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI
import SwiftData

private enum Constants {
    static let screenPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 15
}

struct DreamDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var router: AppRouter
    @Environment(\.dismiss) private var dismiss

    let entry: DreamEntry

    @State private var showDeleteDialog = false
    @State private var showEditSheet = false
    @State private var errorState: AppErrorState?

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                    dateSection
                    dreamContentSection
                    dreamInformation
                    categoryAndMoodSection
                }
                .padding(Constants.screenPadding)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)

            if showDeleteDialog {
                ZStack {
                    Color.black.opacity(0.37)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(LunaraAnimation.quickEase) {
                                showDeleteDialog = false
                            }
                        }

                    ConfirmationDialogView(
                        title: "Delete Dream?",
                        message: "Are you sure you want to delete this dream? This action cannot be undone.",
                        primaryButtonTitle: "Delete Dream",
                        showsCancelButton: true,
                        primaryAction: deleteDream,
                        dismissAction: {
                            withAnimation(LunaraAnimation.quickEase) {
                                showDeleteDialog = false
                            }
                        }
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Dream Detail")
                    .font(.manropeBold(size: 18))
                    .foregroundStyle(LunaraColor.cream)
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    showEditSheet = true
                } label: {
                    Image("edit")
                        .foregroundStyle(LunaraColor.cream)
                }

                Button {
                    withAnimation(LunaraAnimation.quickEase) {
                        showDeleteDialog = true
                    }
                } label: {
                    Image("delete")
                        .foregroundStyle(LunaraColor.cream)
                }
            }
        }
        .overlay {
            if let errorState {
                ZStack {
                    Color.black.opacity(0.37)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(LunaraAnimation.quickEase) {
                                self.errorState = nil
                            }
                        }

                    ConfirmationDialogView(
                        title: errorState.title,
                        message: errorState.message,
                        primaryButtonTitle: "Okay",
                        showsCancelButton: false,
                        primaryAction: {
                            withAnimation(LunaraAnimation.quickEase) {
                                self.errorState = nil
                            }
                        },
                        dismissAction: {
                            withAnimation(LunaraAnimation.quickEase) {
                                self.errorState = nil
                            }
                        }
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
                }
            }
        }
        .animation(LunaraAnimation.quickEase, value: errorState != nil)
        .sheet(isPresented: $showEditSheet) {
            NavigationStack {
                EditDreamView(entry: entry)
            }
            .presentationDragIndicator(.visible)
        }
        .animation(LunaraAnimation.quickEase, value: showDeleteDialog)
    }
}

private extension DreamDetailView {
    var dateSection: some View {
        Text(entry.dreamDate.formatted(.dateTime.weekday(.wide).day().month(.wide).year()))
            .font(.manropeLight(size: 11))
            .textCase(.uppercase)
            .foregroundStyle(LunaraColor.cream.opacity(0.7))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 4)
    }

    var dreamContentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !trimmedTitle.isEmpty {
                Text(trimmedTitle)
                    .font(.manropeSemiBold(size: 18))
                    .foregroundStyle(LunaraColor.cream)
            }

            Text("What happened?")
                .font(.manropeSemiBold(size: 13))
                .foregroundStyle(LunaraColor.cream.opacity(0.75))

            Text(entry.content)
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.9))
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
        }
        .padding(LunaraPadding.screen)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
    }

    var dreamInformation: some View {
        VStack(spacing: 10) {
            InformationRow(
                title: "Dream intensity",
                value: DreamIntensity(rawValue: entry.intensity)?.displayName ?? "\(entry.intensity)"
            )

            InformationRow(
                title: "Created",
                value: entry.created.formatted(date: .abbreviated, time: .shortened)
            )

            InformationRow(
                title: "Modified",
                value: entry.modified.formatted(date: .abbreviated, time: .shortened)
            )
        }
        .padding(LunaraPadding.screen)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
    }

    var categoryAndMoodSection: some View {
        HStack(spacing: 30) {
            VStack(spacing: 10) {
                Image(entry.category.image)
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(entry.category.color)
                    )

                Text("\(entry.category.displayName) dream")
                    .font(.manropeLight(size: 12))
                    .foregroundStyle(LunaraColor.cream)
            }

            VStack(spacing: 10) {
                Image(entry.wakingMood.image)
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(entry.wakingMood.color)
                    )

                Text("Woke up \(entry.wakingMood.displayName)")
                    .font(.manropeLight(size: 12))
                    .foregroundStyle(LunaraColor.cream)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 20)
    }

    var trimmedTitle: String {
        entry.title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
            .fill(LunaraColor.secondary)
            .overlay {
                RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                    .stroke(LunaraColor.border, lineWidth: 1)
            }
    }

    func deleteDream() {
        modelContext.delete(entry)

        do {
            try modelContext.save()
            showDeleteDialog = false
            dismiss()
            router.handleDreamDeleted()
        } catch {
            errorState = AppErrorState(
                title: "Couldn’t Delete Dream",
                message: "Something went wrong while deleting your dream. Please try again."
            )
        }
    }
}

private struct InformationRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .font(.manropeSemiBold(size: 12))
                .foregroundStyle(LunaraColor.cream)

            Spacer()

            Text(value)
                .font(.manropeLight(size: 12))
                .foregroundStyle(LunaraColor.cream.opacity(0.75))
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    NavigationStack {
        DreamDetailView(
            entry: DreamEntry(
                dreamDate: Date(),
                title: "Flying over the city",
                content: "I was flying over a city and everything felt extremely vivid. Then suddenly I was back in school sitting an exam I had not revised for.",
                category: .weird,
                intensity: 4,
                wakingMood: .calm
            )
        )
    }
}
