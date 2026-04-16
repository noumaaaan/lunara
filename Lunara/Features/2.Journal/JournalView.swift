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
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    
                    contentView
                }
                .padding(.horizontal, Constants.screenPadding)
                .padding(.bottom, Constants.bottomContentPadding)
                .padding(.top, displayedDreamEntries.isEmpty ? 72 : 16)
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
                Button {
                    withAnimation(LunaraAnimation.gentleEase) {
                        selectedSortOption = selectedSortOption == .newestFirst
                            ? .oldestFirst
                            : .newestFirst
                    }
                } label: {
                    Image(selectedSortOption == .newestFirst ? "arrowDown" : "arrowUp")
                        .foregroundStyle(LunaraColor.cream)
                        .contentTransition(.opacity)
                }
                .disabled(displayedDreamEntries.isEmpty)
                .opacity(displayedDreamEntries.isEmpty ? 0.45 : 1)
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
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(journalSubtitle)
                .font(LunaraFont.bodySmall)
                .foregroundStyle(LunaraColor.cream)
        }
        .padding(.bottom, displayedDreamEntries.isEmpty ? 8 : 4)
    }
    
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
    
    
    var journalSubtitle: String {
        if hasActiveFilters {
            return "\(displayedDreamEntries.count) \(displayedDreamEntries.count == 1 ? "entry" : "entries") matching your filters"
        } else if allDreamEntries.isEmpty {
            return "Your saved dreams will appear here once you start logging them."
        } else {
            return "\(displayedDreamEntries.count) \(displayedDreamEntries.count == 1 ? "entry" : "entries") saved"
        }
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
        VStack(spacing: 14) {
            Image(systemName: "moon.stars")
                .font(.system(size: 26, weight: .regular))
                .foregroundStyle(LunaraColor.cream.opacity(0.85))

            Text("No dreams logged yet")
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)

            Text("Your saved dreams will appear here once you start logging them.")
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.75))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.bigger, style: .continuous)
                .fill(LunaraColor.secondary.opacity(0.7))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.bigger, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
        .padding(.horizontal, 8)
    }

    var filteredEmptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(LunaraColor.cream.opacity(0.85))

            Text("No matching dreams")
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)

            Text("Try adjusting or clearing your filters to see more entries.")
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
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.bigger, style: .continuous)
                .fill(LunaraColor.secondary.opacity(0.7))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.bigger, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
        .padding(.horizontal, 8)
    }

    func handlePendingSavedDream() {
        guard let pendingID = router.pendingJournalEntryID else { return }

        if let matchingEntry = allDreamEntries.first(where: { $0.id == pendingID }) {
            selectedEntry = matchingEntry
            router.pendingJournalEntryID = nil
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            guard router.pendingJournalEntryID == pendingID else { return }

            if let matchingEntry = allDreamEntries.first(where: { $0.id == pendingID }) {
                selectedEntry = matchingEntry
                router.pendingJournalEntryID = nil
            }
        }
    }
}

#Preview {
    NavigationStack {
        JournalView()
            .environmentObject(AppRouter())
    }
}
