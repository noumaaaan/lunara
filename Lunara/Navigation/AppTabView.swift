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
                .opacity(router.toastMessage == nil ? 1 : 0)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .overlay {
            if let message = router.toastMessage {
                ZStack {
                    Color.black.opacity(0.37)
                        .ignoresSafeArea()

                    SaveHUDView(message: message)
                        .transition(.scale(scale: 0.94).combined(with: .opacity))
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: router.toastMessage)
    }
}

#Preview {
    AppTabView()
}
