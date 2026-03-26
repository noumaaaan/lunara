//
//  JournalView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI
import SwiftData

private enum Constants {
    static let screenPadding: CGFloat = 16
    static let verticalSpacing: CGFloat = 12
    static let bottomContentPadding: CGFloat = 160
}

struct JournalView: View {
    @Query private var allDreamEntries: [DreamEntry]
    @EnvironmentObject private var router: AppRouter

    @State private var selectedSortOption: JournalSortOption = .newestFirst
    @State private var showFilterSheet = false

    @State private var selectedCategories: Set<DreamCategory> = []
    @State private var selectedMoods: Set<WakingMood> = []
    @State private var selectedIntensities: Set<DreamIntensity> = []

    @State private var selectedEntry: DreamEntry?

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            ScrollView {
                contentView
                    .padding(.horizontal, Constants.screenPadding)
                    .padding(.bottom, Constants.bottomContentPadding)
                    .padding(.top, displayedDreamEntries.isEmpty ? 100 : 16)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Journal")
                    .font(.manropeBold(size: 18))
                    .foregroundStyle(LunaraColor.cream)
            }

            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    ForEach(JournalSortOption.allCases, id: \.self) { option in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedSortOption = option
                            }
                        } label: {
                            if selectedSortOption == option {
                                Label(option.displayName, systemImage: "checkmark")
                            } else {
                                Text(option.displayName)
                            }
                        }
                    }
                } label: {
                    Image("sort")
                        .foregroundStyle(LunaraColor.cream)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showFilterSheet = true
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Image("filter")
                            .foregroundStyle(LunaraColor.cream)

                        if hasActiveFilters {
                            Circle()
                                .fill(LunaraColor.pink)
                                .frame(width: 8, height: 8)
                                .offset(x: 4, y: -4)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            JournalFilterSheet(
                selectedCategories: $selectedCategories,
                selectedMoods: $selectedMoods,
                selectedIntensities: $selectedIntensities,
                resetAction: resetFilters
            )
        }
        .navigationDestination(item: $selectedEntry) { entry in
            DreamDetailView(entry: entry)
        }
        .onAppear {
            handlePendingSavedDream()
        }
        .onChange(of: allDreamEntries.count) { _, _ in
            handlePendingSavedDream()
        }
    }
}

private extension JournalView {
    @ViewBuilder
    var contentView: some View {
        if displayedDreamEntries.isEmpty {
            Group {
                if hasActiveFilters {
                    filteredEmptyState
                } else {
                    journalEmptyState
                }
            }
            .frame(maxWidth: .infinity)
        } else {
            LazyVStack(spacing: Constants.verticalSpacing) {
                ForEach(displayedDreamEntries) { entry in
                    Button {
                        selectedEntry = entry
                    } label: {
                        JournalRowView(entry: entry)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    var hasActiveFilters: Bool {
        !selectedCategories.isEmpty
        || !selectedMoods.isEmpty
        || !selectedIntensities.isEmpty
    }

    var displayedDreamEntries: [DreamEntry] {
        let filtered = allDreamEntries.filter { entry in
            matchesCategory(entry)
            && matchesMood(entry)
            && matchesIntensity(entry)
        }

        switch selectedSortOption {
        case .newestFirst:
            return filtered.sorted { $0.created > $1.created }
        case .oldestFirst:
            return filtered.sorted { $0.created < $1.created }
        }
    }

    func matchesCategory(_ entry: DreamEntry) -> Bool {
        selectedCategories.isEmpty || selectedCategories.contains(entry.category)
    }

    func matchesMood(_ entry: DreamEntry) -> Bool {
        selectedMoods.isEmpty || selectedMoods.contains(entry.wakingMood)
    }

    func matchesIntensity(_ entry: DreamEntry) -> Bool {
        guard let entryIntensity = DreamIntensity(rawValue: entry.intensity) else {
            return selectedIntensities.isEmpty
        }
        return selectedIntensities.isEmpty || selectedIntensities.contains(entryIntensity)
    }

    func resetFilters() {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedCategories.removeAll()
            selectedMoods.removeAll()
            selectedIntensities.removeAll()
        }
    }

    var journalEmptyState: some View {
        VStack(spacing: 12) {
            Text("No dreams logged yet")
                .font(.manropeSemiBold(size: 18))
                .foregroundStyle(LunaraColor.cream)

            Text("Start logging your dreams and they’ll appear here in your journal.")
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.75))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
    }

    var filteredEmptyState: some View {
        VStack(spacing: 12) {
            Text("Nothing found")
                .font(.manropeSemiBold(size: 18))
                .foregroundStyle(LunaraColor.cream)

            Text("No dreams match the current filters.")
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.75))
                .multilineTextAlignment(.center)

            CustomButton(
                title: "Reset Filters",
                style: .secondary,
                height: 46
            ) {
                resetFilters()
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 24)
    }

    func handlePendingSavedDream() {
        guard let pendingID = router.pendingJournalEntryID else { return }
        guard let matchingEntry = allDreamEntries.first(where: { $0.id == pendingID }) else { return }

        selectedEntry = matchingEntry
        router.pendingJournalEntryID = nil
    }
}

#Preview {
    NavigationStack {
        JournalView()
            .environmentObject(AppRouter())
    }
}
