//
//  AppTabView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

struct AppTabView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $router.selectedTab) {
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
            .environmentObject(router)

            CustomTabView(selectedTab: $router.selectedTab)
                .opacity(router.savedDreamToastMessage == nil ? 1 : 0)
        }
        .overlay {
            if let message = router.savedDreamToastMessage {
                ZStack {
                    Color.black.opacity(0.37)
                        .ignoresSafeArea()

                    SaveHUDView(message: message)
                        .transition(.scale(scale: 0.94).combined(with: .opacity))
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: router.savedDreamToastMessage)
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
