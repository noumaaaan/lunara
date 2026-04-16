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
    static let calendarTopPadding: CGFloat = 18
    static let calendarCardHeight: CGFloat = 440
    static let calendarInnerPadding: CGFloat = 14
    static let monthHeaderBottomPadding: CGFloat = 16
    static let monthHeaderTopPadding: CGFloat = 8
    static let sectionSpacing: CGFloat = 14
    static let bottomListPadding: CGFloat = 120
    static let dividerTopPadding: CGFloat = 18
    static let selectedDateTopPadding: CGFloat = 10
    static let selectedDateBottomPadding: CGFloat = 10
    static let entriesTopPadding: CGFloat = 18
}

struct CalendarView: View {
    @Query private var allDreamEntries: [DreamEntry]

    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var scrollToDateTrigger: Int = 0
    @State private var visibleMonthDate: Date = Calendar.current.startOfDay(for: Date())

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
                    .font(.manropeBold(size: 18))
                    .foregroundStyle(LunaraColor.cream)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Today") {
                    goToToday()
                }
                .font(LunaraFont.semiBoldSmall)
                .foregroundStyle(shouldDisableTodayButton ? LunaraColor.cream.opacity(0.45) : LunaraColor.cream)
                .disabled(shouldDisableTodayButton)
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
                scrollToDate: calendar.startOfDay(for: Date()),
                scrollToDateTrigger: scrollToDateTrigger,
                onDayTapped: { tappedDate in
                    withAnimation(LunaraAnimation.gentleEase) {
                        selectedDate = tappedDate
                    }
                },
                onVisibleMonthChanged: { monthDate in
                    visibleMonthDate = monthDate
                }
            )
            .frame(height: Constants.calendarCardHeight)
        }
        .padding(.horizontal, Constants.calendarHorizontalPadding)
        .padding(.top, Constants.calendarTopPadding)
        .background(LunaraColor.background)
    }

    var selectedDateSection: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(LunaraColor.border.opacity(0.9))
                .padding(.horizontal, Constants.calendarHorizontalPadding)
                .padding(.top, Constants.dividerTopPadding)

            Text(selectedDate.formatted(.dateTime.weekday(.wide).day().month(.wide).year()))
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, Constants.selectedDateTopPadding)
                .padding(.bottom, Constants.selectedDateBottomPadding)
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
            .padding(.top, Constants.entriesTopPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(dreamsForSelectedDate) { entry in
                        NavigationLink {
                            DreamDetailView(entry: entry)
                        } label: {
                            CalendarRowView(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, LunaraPadding.screen)
                .padding(.top, Constants.entriesTopPadding)
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

    var isViewingCurrentMonth: Bool {
        calendar.isDate(visibleMonthDate, equalTo: Date(), toGranularity: .month)
    }

    func goToToday() {
        withAnimation(LunaraAnimation.quickEase) {
            selectedDate = todayDate
            visibleMonthDate = todayDate
        }

        scrollToDateTrigger += 1
    }
}

// MARK: - Horizon Calendar Wrapper

private struct HorizonCalendarContainerView: UIViewRepresentable {
    let calendar: Calendar
    let visibleDateRange: ClosedRange<Date>
    let selectedDate: Date
    let dreamDates: Set<Date>
    let initialMonthDate: Date
    let scrollToDate: Date
    let scrollToDateTrigger: Int
    let onDayTapped: (Date) -> Void
    let onVisibleMonthChanged: (Date) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> HorizonCalendar.CalendarView {
        let view = HorizonCalendar.CalendarView(initialContent: makeContent())
        view.backgroundColor = .clear
        configureSelectionHandler(for: view)
        configureScrollHandler(for: view)

        DispatchQueue.main.async {
            guard !context.coordinator.didScrollToInitialMonth else { return }
            context.coordinator.didScrollToInitialMonth = true

            view.scroll(
                toMonthContaining: initialMonthDate,
                scrollPosition: .centered,
                animated: false
            )

            notifyVisibleMonthIfNeeded(from: view, coordinator: context.coordinator)
        }

        return view
    }

    func updateUIView(_ uiView: HorizonCalendar.CalendarView, context: Context) {
        configureSelectionHandler(for: uiView)
        configureScrollHandler(for: uiView)
        uiView.backgroundColor = .clear
        uiView.setContent(makeContent())

        if context.coordinator.lastScrollToDateTrigger != scrollToDateTrigger {
            context.coordinator.lastScrollToDateTrigger = scrollToDateTrigger

            uiView.scroll(
                toMonthContaining: scrollToDate,
                scrollPosition: .centered,
                animated: true
            )

            DispatchQueue.main.async {
                notifyVisibleMonthIfNeeded(from: uiView, coordinator: context.coordinator)
            }
        } else {
            DispatchQueue.main.async {
                notifyVisibleMonthIfNeeded(from: uiView, coordinator: context.coordinator)
            }
        }
    }

    func configureSelectionHandler(for view: HorizonCalendar.CalendarView) {
        view.daySelectionHandler = { day in
            guard let tappedDate = calendar.date(from: day.components) else { return }
            let normalized = calendar.startOfDay(for: tappedDate)

            guard normalized <= calendar.startOfDay(for: Date()) else { return }
            onDayTapped(normalized)
        }
    }

    func configureScrollHandler(for view: HorizonCalendar.CalendarView) {
        view.didScroll = { _, _ in
            notifyVisibleMonthIfNeeded(from: view, coordinator: nil)
        }
    }

    func notifyVisibleMonthIfNeeded(
        from view: HorizonCalendar.CalendarView,
        coordinator: Coordinator?
    ) {
        guard let visibleMonth = view.visibleMonthRange?.lowerBound else { return }
        guard let monthDate = calendar.date(from: visibleMonth.components) else { return }

        let normalizedMonthDate = calendar.date(
            from: calendar.dateComponents([.year, .month], from: monthDate)
        ) ?? monthDate

        if let coordinator {
            if coordinator.lastVisibleMonthDate == normalizedMonthDate { return }
            coordinator.lastVisibleMonthDate = normalizedMonthDate
        }

        onVisibleMonthChanged(normalizedMonthDate)
    }

    private func makeContent() -> CalendarViewContent {
        CalendarViewContent(
            calendar: calendar,
            visibleDateRange: visibleDateRange,
            monthsLayout: .horizontal(
                options: HorizontalMonthsLayoutOptions()
            )
        )
        .monthHeaderItemProvider { month in
            CalendarMonthHeaderItemView(
                month: calendar.date(from: month.components)!
            )
            .calendarItemModel
        }
        .dayOfWeekItemProvider { _, weekday in
            CalendarWeekdayItemView(
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
        var lastScrollToDateTrigger: Int = 0
        var lastVisibleMonthDate: Date?
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
            .padding(.top, Constants.monthHeaderTopPadding)
            .padding(.bottom, Constants.monthHeaderBottomPadding)
            .frame(height: 52, alignment: .bottomLeading)
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
                .font(dayFont)
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

    private var dayFont: Font {
        if isToday && !isSelected {
            return .manropeSemiBold(size: 14)
        }
        return LunaraFont.bodySmall
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

private extension CalendarView {
    var todayDate: Date {
        calendar.startOfDay(for: Date())
    }

    var isTodaySelected: Bool {
        calendar.isDate(selectedDate, inSameDayAs: todayDate)
    }

    var shouldDisableTodayButton: Bool {
        isTodaySelected && isViewingCurrentMonth
    }
}

#Preview {
    NavigationStack {
        CalendarView()
            .modelContainer(for: DreamEntry.self, inMemory: true)
            .environmentObject(AppRouter())
    }
}
