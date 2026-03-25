//
//  AppTabView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

struct AppTabView: View {
    @State private var selectedTab: TabOption = .log

    var body: some View {
        ZStack(alignment: .bottom) {
            
            LunaraColor.background.ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                CalendarView()
                    .tag(TabOption.calendar)
                    .toolbar(.hidden, for: .tabBar)

                JournalView()
                    .tag(TabOption.journal)
                    .toolbar(.hidden, for: .tabBar)

                LogDreamView()
                    .tag(TabOption.log)
                    .toolbar(.hidden, for: .tabBar)

                InsightsView()
                    .tag(TabOption.insights)
                    .toolbar(.hidden, for: .tabBar)

                PreferencesView()
                    .tag(TabOption.preferences)
                    .toolbar(.hidden, for: .tabBar)
            }
            
            CustomTabView(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    AppTabView()
}
