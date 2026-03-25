//
//  AppTabView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

struct AppTabView: View {
    @State private var selectedTab: TabOption = .log
    @StateObject private var keyboard = KeyboardObserver()

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    CalendarView()
                        .toolbar(.hidden, for: .tabBar)
                }
                .tag(TabOption.calendar)

                NavigationStack {
                    JournalView()
                        .toolbar(.hidden, for: .tabBar)
                }
                .tag(TabOption.journal)

                NavigationStack {
                    LogDreamScreenOneView()
                        .toolbar(.hidden, for: .tabBar)
                }
                .tag(TabOption.log)

                NavigationStack {
                    InsightsView()
                        .toolbar(.hidden, for: .tabBar)
                }
                .tag(TabOption.insights)

                NavigationStack {
                    PreferencesView()
                        .toolbar(.hidden, for: .tabBar)
                }
                .tag(TabOption.preferences)
            }

            if !keyboard.isKeyboardVisible {
                CustomTabView(selectedTab: $selectedTab)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: keyboard.isKeyboardVisible)
    }
}

#Preview {
    AppTabView()
}

import SwiftUI
import Combine

final class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .merge(
                with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false }
            )
            .receive(on: RunLoop.main)
            .assign(to: &$isKeyboardVisible)
    }
}
