//
//  CalendarView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI
import SwiftData
import HorizonCalendar

private enum Constants {
    static let calendarHorizontalPadding: CGFloat = 16
    static let calendarTopPadding: CGFloat = 12
    static let calendarCardHeight: CGFloat = 410
    static let calendarInnerPadding: CGFloat = 14
    static let sectionSpacing: CGFloat = 14
    static let bottomListPadding: CGFloat = 120
    static let dividerTopPadding: CGFloat = 14
}

struct CalendarView: View {
    @Query private var allDreamEntries: [DreamEntry]

    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())

    private let calendar = Calendar.current

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                calendarSection
                selectedDateSection
                entriesSection
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Calendar")
                    .font(LunaraFont.bold)
                    .foregroundStyle(LunaraColor.cream)
            }
        }
    }
}

private extension CalendarView {
    var calendarSection: some View {
        VStack(spacing: 0) {
            HorizonCalendarContainerView(
                calendar: calendar,
                visibleDateRange: visibleDateRange,
                selectedDate: selectedDate,
                dreamDates: dreamDatesForLookup,
                initialMonthDate: firstDayOfCurrentMonth,
                onDayTapped: { tappedDate in
                    withAnimation(LunaraAnimation.gentleEase) {
                        selectedDate = tappedDate
                    }
                }
            )
            .frame(height: Constants.calendarCardHeight)
        }
        .padding(.horizontal, Constants.calendarHorizontalPadding)
        .padding(.top, Constants.calendarTopPadding)
        .background(LunaraColor.background)
    }

    var selectedDateSection: some View {
        VStack(spacing: 10) {
            Divider()
                .overlay(LunaraColor.border.opacity(0.9))
                .padding(.horizontal, Constants.calendarHorizontalPadding)
                .padding(.top, Constants.dividerTopPadding)

            Text(selectedDate.formatted(.dateTime.weekday(.wide).day().month(.wide).year()))
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 6)
        }
    }

    @ViewBuilder
    var entriesSection: some View {
        if dreamsForSelectedDate.isEmpty {
            VStack(spacing: 12) {
                Text("No dreams logged for this date")
                    .font(LunaraFont.semiBold)
                    .foregroundStyle(LunaraColor.cream)

                Text("Dreams you log on this day will appear here.")
                    .font(LunaraFont.body)
                    .foregroundStyle(LunaraColor.cream.opacity(0.75))
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: LunaraRadius.bigger, style: .continuous)
                    .fill(LunaraColor.secondary.opacity(0.65))
                    .overlay {
                        RoundedRectangle(cornerRadius: LunaraRadius.bigger, style: .continuous)
                            .stroke(LunaraColor.cream.opacity(0.24), lineWidth: 1)
                    }
            )
            .padding(.horizontal, LunaraPadding.screen)
            .padding(.top, Constants.sectionSpacing)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(dreamsForSelectedDate) { entry in
                        NavigationLink {
                            DreamDetailView(entry: entry)
                        } label: {
                            JournalRowView(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, LunaraPadding.screen)
                .padding(.top, Constants.sectionSpacing)
                .padding(.bottom, Constants.bottomListPadding)
            }
            .scrollIndicators(.hidden)
        }
    }

    var firstDayOfCurrentMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: components)!
    }

    var visibleDateRange: ClosedRange<Date> {
        let start = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let end = calendar.startOfDay(for: Date())
        return start...end
    }

    var dreamDatesForLookup: Set<Date> {
        Set(allDreamEntries.map { calendar.startOfDay(for: $0.dreamDate) })
    }

    var dreamsForSelectedDate: [DreamEntry] {
        allDreamEntries
            .filter { calendar.isDate($0.dreamDate, inSameDayAs: selectedDate) }
            .sorted { $0.created > $1.created }
    }
}

// MARK: - Horizon Calendar Wrapper

private struct HorizonCalendarContainerView: UIViewRepresentable {
    let calendar: Calendar
    let visibleDateRange: ClosedRange<Date>
    let selectedDate: Date
    let dreamDates: Set<Date>
    let initialMonthDate: Date
    let onDayTapped: (Date) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> HorizonCalendar.CalendarView {
        let view = HorizonCalendar.CalendarView(initialContent: makeContent())
        view.backgroundColor = .clear

        view.daySelectionHandler = { day in
            guard let tappedDate = calendar.date(from: day.components) else { return }
            let normalized = calendar.startOfDay(for: tappedDate)

            guard normalized <= calendar.startOfDay(for: Date()) else { return }
            onDayTapped(normalized)
        }

        DispatchQueue.main.async {
            guard !context.coordinator.didScrollToInitialMonth else { return }
            context.coordinator.didScrollToInitialMonth = true

            view.scroll(
                toMonthContaining: initialMonthDate,
                scrollPosition: .centered,
                animated: false)
        }

        return view
    }

    func updateUIView(_ uiView: HorizonCalendar.CalendarView, context: Context) {
        uiView.daySelectionHandler = { day in
            guard let tappedDate = calendar.date(from: day.components) else { return }
            let normalized = calendar.startOfDay(for: tappedDate)

            guard normalized <= calendar.startOfDay(for: Date()) else { return }
            onDayTapped(normalized)
        }

        uiView.backgroundColor = .clear
        uiView.setContent(makeContent())
    }

    private func makeContent() -> CalendarViewContent {
        CalendarViewContent(
            calendar: calendar,
            visibleDateRange: visibleDateRange,
            monthsLayout: .horizontal(
                options: HorizontalMonthsLayoutOptions())
        )
        .monthHeaderItemProvider { month in
            return CalendarMonthHeaderItemView(
                month: calendar.date(from: month.components)!
            )
            .calendarItemModel
        }
        .dayOfWeekItemProvider { _, weekday in
            return CalendarWeekdayItemView(
                weekdayIndex: weekday
            )
            .calendarItemModel
        }
        .dayItemProvider { day in
            let date = calendar.date(from: day.components)!
            let normalizedDate = calendar.startOfDay(for: date)
            let isFuture = normalizedDate > calendar.startOfDay(for: Date())

            return CalendarDayItemView(
                dayNumber: day.day,
                isSelected: calendar.isDate(normalizedDate, inSameDayAs: selectedDate),
                isToday: calendar.isDateInToday(normalizedDate),
                hasDream: dreamDates.contains(normalizedDate),
                isFuture: isFuture
            )
            .calendarItemModel
        }
        .interMonthSpacing(16)
        .verticalDayMargin(6)
        .horizontalDayMargin(6)
    }

    final class Coordinator {
        var didScrollToInitialMonth = false
    }
}

// MARK: - Calendar Item Views

private struct CalendarMonthHeaderItemView: View {
    let month: Date

    var body: some View {
        Text(month.formatted(.dateTime.month(.wide).year()))
            .font(.manropeSemiBold(size: 24))
            .foregroundStyle(LunaraColor.cream)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Constants.calendarInnerPadding)
            .padding(.top, 2)
            .padding(.bottom, 12)
    }
}

private struct CalendarWeekdayItemView: View {
    let weekdayIndex: Int

    var body: some View {
        Text(symbol)
            .font(LunaraFont.lightSmall)
            .foregroundStyle(LunaraColor.cream.opacity(0.65))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var symbol: String {
        let symbols = Calendar.current.veryShortStandaloneWeekdaySymbols
        let safeIndex = max(0, min(symbols.count - 1, weekdayIndex - 1))
        return symbols[safeIndex].uppercased()
    }
}

private struct CalendarDayItemView: View {
    let dayNumber: Int
    let isSelected: Bool
    let isToday: Bool
    let hasDream: Bool
    let isFuture: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text("\(dayNumber)")
                .font(LunaraFont.bodySmall)
                .foregroundStyle(textColor)

            Circle()
                .fill(hasDream && !isFuture ? LunaraColor.pink : .clear)
                .frame(width: 5, height: 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.small, style: .continuous)
                .fill(backgroundColor)
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.small, style: .continuous)
                        .stroke(borderColor, lineWidth: borderWidth)
                }
        )
        .opacity(isFuture ? 0.28 : 1)
    }

    private var textColor: Color {
        if isFuture { return LunaraColor.cream.opacity(0.45) }
        if isSelected { return LunaraColor.background }
        if isToday { return LunaraColor.cream }
        return LunaraColor.cream.opacity(0.94)
    }

    private var backgroundColor: Color {
        if isSelected { return LunaraColor.cream }
        return .clear
    }

    private var borderColor: Color {
        if isToday && !isSelected && !isFuture {
            return LunaraColor.cream.opacity(0.5)
        }
        return .clear
    }

    private var borderWidth: CGFloat {
        isToday && !isSelected && !isFuture ? 1 : 0
    }
}

#Preview {
    NavigationStack {
        CalendarView()
            .modelContainer(for: DreamEntry.self, inMemory: true)
            .environmentObject(AppRouter())
    }
}
