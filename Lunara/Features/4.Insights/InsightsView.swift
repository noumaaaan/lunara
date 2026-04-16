//
//  InsightsView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI
import SwiftData

private enum Constants {
    static let screenPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 26
    static let gridSpacing: CGFloat = 12
    static let cardPadding: CGFloat = 16
    static let summaryCardPadding: CGFloat = 18
    static let bottomContentPadding: CGFloat = 110
    static let barHeight: CGFloat = 10
    static let activityChartHeight: CGFloat = 150
    static let sectionHeaderSpacing: CGFloat = 12
}

struct InsightsView: View {
    @Query private var allDreamEntries: [DreamEntry]

    private let calendar = Calendar.current

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            if allDreamEntries.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                        summaryInsightCard
                        overviewSection
                        categoryBreakdownSection
                        moodBreakdownSection
                        activitySection
                    }
                    .padding(.horizontal, LunaraPadding.screen)
                    .padding(.top, LunaraPadding.screen)
                    .padding(.bottom, Constants.bottomContentPadding)
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Insights")
                    .font(.manropeBold(size: 18))
                    .foregroundStyle(LunaraColor.cream)
            }
        }
    }
}

private extension InsightsView {
    var overviewColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: Constants.gridSpacing),
            GridItem(.flexible(), spacing: Constants.gridSpacing)
        ]
    }

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
            .fill(LunaraColor.secondary.opacity(0.72))
            .overlay {
                RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                    .stroke(LunaraColor.border, lineWidth: 1)
            }
    }

    var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 28, weight: .regular))
                .foregroundStyle(LunaraColor.cream.opacity(0.85))

            Text("No insights yet")
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)

            Text("Start logging dreams to uncover patterns over time.")
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.75))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.bigger, style: .continuous)
                .fill(LunaraColor.secondary.opacity(0.72))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.bigger, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
        .padding(.horizontal, LunaraPadding.screen)
    }

    var summaryInsightCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(LunaraColor.pink)

                Text(summaryInsightTitle)
                    .font(LunaraFont.lightExtraSmall)
                    .foregroundStyle(LunaraColor.cream.opacity(0.72))
                    .textCase(.uppercase)
            }

            Text(summaryInsightText)
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.summaryCardPadding)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                .fill(LunaraColor.tertiary.opacity(0.58))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
    }

    var overviewSection: some View {
        VStack(alignment: .leading, spacing: Constants.sectionHeaderSpacing) {
            sectionTitle("Overview")

            LazyVGrid(
                columns: overviewColumns,
                spacing: Constants.gridSpacing
            ) {
                InsightSummaryCardView(
                    title: "Total Dreams",
                    value: "\(allDreamEntries.count)",
                    iconName: "moon.stars.fill",
                    iconColor: LunaraColor.pink
                )

                InsightSummaryCardView(
                    title: "Average Intensity",
                    value: averageIntensityText,
                    iconName: "bolt.fill",
                    iconColor: LunaraColor.tertiary
                )

                InsightSummaryCardView(
                    title: "Top Category",
                    value: mostCommonCategory?.displayName ?? "—",
                    iconName: "sparkles",
                    iconColor: mostCommonCategory?.color ?? LunaraColor.pink
                )

                InsightSummaryCardView(
                    title: "Top Mood",
                    value: mostCommonMood?.displayName ?? "—",
                    iconName: "face.smiling.fill",
                    iconColor: mostCommonMood?.color ?? LunaraColor.cream
                )
            }
        }
    }

    var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: Constants.sectionHeaderSpacing) {
            sectionTitle("Dream Categories")

            VStack(spacing: 12) {
                ForEach(categoryBreakdown, id: \.category) { item in
                    InsightBarRowView(
                        title: item.category.displayName,
                        valueText: categoryValueText(for: item.count),
                        progress: item.progress,
                        fillColor: item.category.color
                    )
                }
            }
        }
    }

    var moodBreakdownSection: some View {
        VStack(alignment: .leading, spacing: Constants.sectionHeaderSpacing) {
            sectionTitle("Waking Moods")

            VStack(spacing: 12) {
                ForEach(moodBreakdown, id: \.mood) { item in
                    InsightBarRowView(
                        title: item.mood.displayName,
                        valueText: moodValueText(for: item.count),
                        progress: item.progress,
                        fillColor: item.mood.color
                    )
                }
            }
        }
    }

    var activitySection: some View {
        VStack(alignment: .leading, spacing: Constants.sectionHeaderSpacing) {
            sectionTitle("Last 4 Weeks")

            InsightActivityChartView(items: lastFourWeeksActivity)
        }
    }

    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(LunaraFont.semiBold)
            .foregroundStyle(LunaraColor.cream)
    }

    func categoryValueText(for count: Int) -> String {
        count == 1 ? "1 dream" : "\(count) dreams"
    }

    func moodValueText(for count: Int) -> String {
        count == 1 ? "1 time" : "\(count) times"
    }

    var summaryInsightTitle: String {
        allDreamEntries.count < 3 ? "Still Learning" : "Pattern"
    }

    var summaryInsightText: String {
        guard allDreamEntries.count >= 3 else {
            return "We’re still learning from your dreams. Log a few more to reveal patterns over time."
        }

        let recentWeeks = lastFourWeeksActivity
        let mostRecentWeekCount = recentWeeks.last?.count ?? 0
        let previousWeekCount = recentWeeks.dropLast().last?.count ?? 0

        let trendText: String
        if mostRecentWeekCount > previousWeekCount {
            trendText = "You’ve been logging more dreams this week."
        } else if mostRecentWeekCount < previousWeekCount {
            trendText = "You logged fewer dreams this week than last week."
        } else {
            trendText = "Your logging pace has been steady recently."
        }

        if let category = mostCommonCategory, let mood = mostCommonMood {
            return "Your dreams have mostly been \(category.displayName.lowercased()) lately, and you most often wake up feeling \(mood.displayName.lowercased()). \(trendText)"
        }

        if let category = mostCommonCategory {
            return "Your dreams have mostly been \(category.displayName.lowercased()) lately. \(trendText)"
        }

        if let mood = mostCommonMood {
            return "You most often wake up feeling \(mood.displayName.lowercased()). \(trendText)"
        }

        return trendText
    }

    var averageIntensityText: String {
        guard !allDreamEntries.isEmpty else { return "—" }
        let average = Double(allDreamEntries.map(\.intensity).reduce(0, +)) / Double(allDreamEntries.count)
        return String(format: "%.1f / 5", average)
    }

    var mostCommonCategory: DreamCategory? {
        Dictionary(grouping: allDreamEntries, by: \.category)
            .max { $0.value.count < $1.value.count }?
            .key
    }

    var mostCommonMood: WakingMood? {
        Dictionary(grouping: allDreamEntries, by: \.wakingMood)
            .max { $0.value.count < $1.value.count }?
            .key
    }

    var categoryBreakdown: [(category: DreamCategory, count: Int, progress: CGFloat)] {
        let grouped = Dictionary(grouping: allDreamEntries, by: \.category)
            .map { (category: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }

        let maxCount = max(grouped.first?.count ?? 1, 1)

        return grouped.map {
            (
                category: $0.category,
                count: $0.count,
                progress: CGFloat($0.count) / CGFloat(maxCount)
            )
        }
    }

    var moodBreakdown: [(mood: WakingMood, count: Int, progress: CGFloat)] {
        let grouped = Dictionary(grouping: allDreamEntries, by: \.wakingMood)
            .map { (mood: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }

        let maxCount = max(grouped.first?.count ?? 1, 1)

        return grouped.map {
            (
                mood: $0.mood,
                count: $0.count,
                progress: CGFloat($0.count) / CGFloat(maxCount)
            )
        }
    }

    var lastFourWeeksActivity: [InsightActivityPoint] {
        let today = calendar.startOfDay(for: Date())
        let currentWeekStart = startOfWeek(for: today)

        let weekStarts: [Date] = (0..<4).compactMap {
            calendar.date(byAdding: .weekOfYear, value: -$0, to: currentWeekStart)
        }.reversed()

        let grouped = Dictionary(grouping: allDreamEntries) { entry in
            startOfWeek(for: entry.dreamDate)
        }

        let rows = weekStarts.map { weekStart in
            InsightActivityPoint(
                weekStart: weekStart,
                count: grouped[weekStart]?.count ?? 0
            )
        }

        let maxCount = max(rows.map(\.count).max() ?? 1, 1)

        return rows.map {
            InsightActivityPoint(
                weekStart: $0.weekStart,
                count: $0.count,
                progress: CGFloat($0.count) / CGFloat(maxCount)
            )
        }
    }

    func startOfWeek(for date: Date) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components) ?? calendar.startOfDay(for: date)
    }
}

private struct InsightActivityPoint {
    let weekStart: Date
    let count: Int
    var progress: CGFloat = 0
}

private struct InsightSummaryCardView: View {
    let title: String
    let value: String
    let iconName: String
    let iconColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(iconColor)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(LunaraFont.lightExtraSmall)
                    .foregroundStyle(LunaraColor.cream.opacity(0.68))
                    .textCase(.uppercase)

                Text(value)
                    .font(.manropeSemiBold(size: 20))
                    .foregroundStyle(LunaraColor.cream)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                .fill(LunaraColor.secondary.opacity(0.72))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
    }
}

private struct InsightBarRowView: View {
    let title: String
    let valueText: String
    let progress: CGFloat
    let fillColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(LunaraFont.bodySmall)
                    .foregroundStyle(LunaraColor.cream)

                Spacer()

                Text(valueText)
                    .font(LunaraFont.semiBoldSmall)
                    .foregroundStyle(LunaraColor.cream.opacity(0.78))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Constants.barHeight / 2, style: .continuous)
                        .fill(LunaraColor.secondary.opacity(0.45))

                    RoundedRectangle(cornerRadius: Constants.barHeight / 2, style: .continuous)
                        .fill(fillColor)
                        .frame(width: max(geo.size.width * progress, progress > 0 ? 12 : 0))
                }
            }
            .frame(height: Constants.barHeight)
        }
        .padding(Constants.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                .fill(LunaraColor.secondary.opacity(0.72))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
    }
}

private struct InsightActivityChartView: View {
    let items: [InsightActivityPoint]

    private static let weekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Dreams logged per week")
                .font(LunaraFont.lightExtraSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.68))
                .textCase(.uppercase)

            HStack(alignment: .bottom, spacing: 12) {
                ForEach(items, id: \.weekStart) { item in
                    VStack(spacing: 8) {
                        GeometryReader { geo in
                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(LunaraColor.secondary.opacity(0.35))

                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(LunaraColor.pink)
                                    .frame(height: max(geo.size.height * item.progress, item.count > 0 ? 16 : 6))
                            }
                        }

                        Text(shortWeekLabel(for: item.weekStart))
                            .font(LunaraFont.lightExtraSmall)
                            .foregroundStyle(LunaraColor.cream.opacity(0.7))

                        Text("\(item.count)")
                            .font(LunaraFont.semiBoldExtraSmall)
                            .foregroundStyle(LunaraColor.cream)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: Constants.activityChartHeight)
        }
        .padding(Constants.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                .fill(LunaraColor.secondary.opacity(0.72))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
    }

    private func shortWeekLabel(for date: Date) -> String {
        Self.weekFormatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        InsightsView()
            .modelContainer(for: DreamEntry.self, inMemory: true)
            .environmentObject(AppRouter())
    }
}
