//
//  LunaraApp.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 24/03/2026.
//

import SwiftUI
import SwiftData

@main
struct LunaraApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: DreamEntry.self)
    }
}
