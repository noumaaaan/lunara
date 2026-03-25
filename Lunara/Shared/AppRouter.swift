//
//  AppRouter.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import Foundation
import Combine
import SwiftUI

final class AppRouter: ObservableObject {
    @Published var selectedTab: TabOption = .log
    @Published var savedDreamToastMessage: String?
    @Published var pendingJournalEntryID: UUID?
}
